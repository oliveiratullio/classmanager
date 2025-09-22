import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

type RoomsAvailabilityParams = {
  dayOfWeek?: number;
  dayStart: string; // HH:MM:SS
  dayEnd: string;   // HH:MM:SS
};

@Injectable()
export class AnalyticsService {
  constructor(private readonly ds: DataSource) {}

  async getProfessorsWeeklyHours() {
    const sql = `
      SELECT
        p.id   AS professor_id,
        p.name AS professor,
        ROUND(
          SUM(EXTRACT(EPOCH FROM (cs.end_time - cs.start_time)) / 3600.0)
        , 2) AS hours_per_week
      FROM professor p
      JOIN subject s       ON s.professor_id = p.id
      JOIN class c         ON c.subject_id   = s.id
      JOIN class_schedule cs ON cs.class_id  = c.id
      GROUP BY p.id, p.name
      ORDER BY p.name;
    `;
    return this.ds.query(sql);
  }

  async getRoomsAvailability(params: RoomsAvailabilityParams) {
    const { dayOfWeek, dayStart, dayEnd } = params;

    const sql = `
      WITH params AS (
        SELECT make_time(cast(split_part($1, ':', 1) as int),
                         cast(split_part($1, ':', 2) as int),
                         cast(split_part($1, ':', 3) as int))  AS day_start,
               make_time(cast(split_part($2, ':', 1) as int),
                         cast(split_part($2, ':', 2) as int),
                         cast(split_part($2, ':', 3) as int))  AS day_end
      ),
      rooms_days AS (
        SELECT r.id AS room_id, d.day_of_week
        FROM room r
        CROSS JOIN (VALUES (1),(2),(3),(4),(5),(6),(7)) AS d(day_of_week)
        ${dayOfWeek ? 'WHERE d.day_of_week = $3' : ''}
      ),
      base_events AS (
        SELECT cs.room_id, cs.day_of_week, cs.start_time AS t, 1 AS kind
        FROM class_schedule cs
        ${dayOfWeek ? 'WHERE cs.day_of_week = $3' : ''}
        UNION ALL
        SELECT cs.room_id, cs.day_of_week, cs.end_time   AS t, 2 AS kind
        FROM class_schedule cs
        ${dayOfWeek ? 'WHERE cs.day_of_week = $3' : ''}
      ),
      events AS (
        SELECT * FROM base_events
        UNION ALL
        SELECT rd.room_id, rd.day_of_week, (SELECT day_start FROM params), 0 FROM rooms_days rd
        UNION ALL
        SELECT rd.room_id, rd.day_of_week, (SELECT day_end   FROM params), 3 FROM rooms_days rd
      ),
      ordered AS (
        SELECT
          room_id,
          day_of_week,
          t,
          kind,
          LEAD(t) OVER (PARTITION BY room_id, day_of_week ORDER BY t, kind) AS next_t,
          SUM(CASE WHEN kind=1 THEN 1 WHEN kind=2 THEN -1 ELSE 0 END)
            OVER (PARTITION BY room_id, day_of_week ORDER BY t, kind
                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS open_classes
        FROM events
      )
      SELECT
        o.room_id,
        o.day_of_week,
        o.t      AS start_time,
        o.next_t AS end_time,
        CASE WHEN o.open_classes > 0 THEN 'occupied' ELSE 'free' END AS status
      FROM ordered o, params p
      WHERE o.next_t IS NOT NULL
        AND o.t      >= p.day_start
        AND o.next_t <= p.day_end
        AND o.t < o.next_t
      ORDER BY o.room_id, o.day_of_week, o.t;
    `;

    const binds = dayOfWeek ? [dayStart, dayEnd, dayOfWeek] : [dayStart, dayEnd];
    return this.ds.query(sql, binds);
  }
}
