import { TestBed } from '@angular/core/testing';

import { NotificationEngineService } from './notification-engine.service';

describe('NotificationEngineService', () => {
  let service: NotificationEngineService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(NotificationEngineService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
