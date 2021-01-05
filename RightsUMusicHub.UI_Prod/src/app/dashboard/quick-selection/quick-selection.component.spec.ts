import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { QuickSelectionComponent } from './quick-selection.component';

describe('QuickSelectionComponent', () => {
  let component: QuickSelectionComponent;
  let fixture: ComponentFixture<QuickSelectionComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ QuickSelectionComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(QuickSelectionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
