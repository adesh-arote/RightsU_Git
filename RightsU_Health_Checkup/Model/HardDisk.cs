using System;

namespace RightsU_HealthCheckup.Model
{
    public class HardDisk
    {
        public string DriveName { get; set; }
        public string TotalSize { get; set; }
        public string AvailableFreeSpace { get; set; }
        public string TotalFreeSpace { get; set; }
        public string ColorAFS { get; set; }
    }
}
