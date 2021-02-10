import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CommonMusicAssignmentComponent } from './common-music-assignment.component';

describe('CommonMusicAssignmentComponent', () => {
  let component: CommonMusicAssignmentComponent;
  let fixture: ComponentFixture<CommonMusicAssignmentComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CommonMusicAssignmentComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CommonMusicAssignmentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
