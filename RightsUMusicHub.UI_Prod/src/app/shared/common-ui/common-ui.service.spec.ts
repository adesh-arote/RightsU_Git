import { TestBed, inject } from '@angular/core/testing';

import { CommonUiService } from './common-ui.service';

describe('CommonUiService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [CommonUiService]
    });
  });

  it('should be created', inject([CommonUiService], (service: CommonUiService) => {
    expect(service).toBeTruthy();
  }));
});
