import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AuthorizedMusicComponent } from './authorized-music.component';

describe('AuthorizedMusicComponent', () => {
  let component: AuthorizedMusicComponent;
  let fixture: ComponentFixture<AuthorizedMusicComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AuthorizedMusicComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AuthorizedMusicComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
