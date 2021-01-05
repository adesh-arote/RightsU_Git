import { RequisitionModule } from './requisition.module';

describe('RequisitionModule', () => {
  let requisitionModule: RequisitionModule;

  beforeEach(() => {
    requisitionModule = new RequisitionModule();
  });

  it('should create an instance', () => {
    expect(requisitionModule).toBeTruthy();
  });
});
