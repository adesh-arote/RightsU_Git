import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CommonMusicTrackComponent } from './common-music-track.component';

describe('CommonMusicTrackComponent', () => {
  let component: CommonMusicTrackComponent;
  let fixture: ComponentFixture<CommonMusicTrackComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CommonMusicTrackComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CommonMusicTrackComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
