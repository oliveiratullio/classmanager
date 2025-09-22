import { Controller, Get, Query } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';

@Controller('analytics')
export class AnalyticsController {
  constructor(private readonly service: AnalyticsService) {}

  @Get('professors-hours')
  getProfessorsHours() {
    return this.service.getProfessorsWeeklyHours();
  }

  @Get('rooms-availability')
  getRoomsAvailability(
    @Query('dayOfWeek') dayOfWeek?: string,
    @Query('start') start = '08:00:00',
    @Query('end') end = '22:00:00'
  ) {
    return this.service.getRoomsAvailability({
      dayOfWeek: dayOfWeek ? Number(dayOfWeek) : undefined,
      dayStart: start,
      dayEnd: end
    });
  }
}
