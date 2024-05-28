import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MusicAssignmentComponent } from './music-assignment.component';

describe('MusicAssignmentComponent', () => {
  let component: MusicAssignmentComponent;
  let fixture: ComponentFixture<MusicAssignmentComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MusicAssignmentComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MusicAssignmentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
