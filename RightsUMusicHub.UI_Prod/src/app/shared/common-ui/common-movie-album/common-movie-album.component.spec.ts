import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CommonMovieAlbumComponent } from './common-movie-album.component';

describe('CommonMovieAlbumComponent', () => {
  let component: CommonMovieAlbumComponent;
  let fixture: ComponentFixture<CommonMovieAlbumComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CommonMovieAlbumComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CommonMovieAlbumComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
