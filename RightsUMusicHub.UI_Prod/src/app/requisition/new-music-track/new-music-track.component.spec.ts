import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NewMusicTrackComponent } from './new-music-track.component';

describe('NewMusicTrackComponent', () => {
  let component: NewMusicTrackComponent;
  let fixture: ComponentFixture<NewMusicTrackComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NewMusicTrackComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NewMusicTrackComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
