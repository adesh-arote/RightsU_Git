import { MusicAssignmentModule } from './music-assignment.module';

describe('MusicAssignmentModule', () => {
  let musicAssignmentModule: MusicAssignmentModule;

  beforeEach(() => {
    musicAssignmentModule = new MusicAssignmentModule();
  });

  it('should create an instance', () => {
    expect(musicAssignmentModule).toBeTruthy();
  });
});
