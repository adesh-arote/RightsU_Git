﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_SchedulerService
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class RightsU_PlusEntities : DbContext
    {
        public RightsU_PlusEntities()
            : base("name=RightsU_PlusEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<SchedulerConfig> SchedulerConfigs { get; set; }
        public virtual DbSet<Title> Titles { get; set; }
        public virtual DbSet<Scheduler_Log> Scheduler_Log { get; set; }
        public virtual DbSet<SchedulerRight> SchedulerRights { get; set; }
    
        public virtual ObjectResult<USP_Acq_Rights_Model_Result> USP_Acq_Rights_Model()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<USP_Acq_Rights_Model_Result>("USP_Acq_Rights_Model");
        }
    
        public virtual ObjectResult<USP_Acq_Assets_Model_Result> USP_Acq_Assets_Model(string callFor, Nullable<int> batchSize)
        {
            var callForParameter = callFor != null ?
                new ObjectParameter("callFor", callFor) :
                new ObjectParameter("callFor", typeof(string));
    
            var batchSizeParameter = batchSize.HasValue ?
                new ObjectParameter("BatchSize", batchSize) :
                new ObjectParameter("BatchSize", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<USP_Acq_Assets_Model_Result>("USP_Acq_Assets_Model", callForParameter, batchSizeParameter);
        }
    }
}
