import { TestBed, inject } from '@angular/core/testing';

import { MusicAssignmentService } from './music-assignment.service';

describe('MusicAssignmentService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [MusicAssignmentService]
    });
  });

  it('should be created', inject([MusicAssignmentService], (service: MusicAssignmentService) => {
    expect(service).toBeTruthy();
  }));
});
