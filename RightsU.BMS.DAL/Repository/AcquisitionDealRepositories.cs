using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class AcquisitionDealRepositories : MainRepository<Acq_Deal_Rights>
    {
        public Acq_Deal_Rights GetById(Int32? Id)
        {
            var obj = new { Acq_Deal_Rights_Code = Id.Value };
            //var entity = base.GetById<Acq_Deal_Rights, Sub_License, Acq_Deal_Rights_Title, Title, Acq_Deal_Rights_Territory, Territory, Country, Acq_Deal_Rights_Platform>(obj);
            var entity = base.GetById<Acq_Deal_Rights, Sub_License, Acq_Deal_Rights_Title, Acq_Deal_Rights_Platform, Acq_Deal_Rights_Territory, Acq_Deal_Rights_Subtitling, Acq_Deal_Rights_Dubbing>(obj);

            return entity;
        }

        public void Add(Acq_Deal_Rights entity)
        {
            base.AddEntity(entity);
        }

        public void Delete(Acq_Deal_Rights entity)
        {
            base.DeleteEntity(entity);
        }
    }
}
