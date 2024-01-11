using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class DealGeneralRepositories : MainRepository<Acq_Deal>
    {
        public Acq_Deal GetById(Int32? Id)
        {
            var obj = new { Acq_Deal_Code = Id.Value };
            var entity = base.GetById<Acq_Deal, Acq_Deal_Licensor, Acq_Deal_Movie, Deal_Type, Deal_Tag, Role, Entity>(obj);

            if (entity.primary_vendor == null)
            {
                entity.primary_vendor = new VendorRepositories().Get(entity.Vendor_Code.Value);
            }

            if (entity.Currency == null)
            {
                entity.Currency = new CurrencyRepositories().Get(entity.Currency_Code.Value);
            }

            if (entity.business_unit == null)
            {
                entity.business_unit = new BusinessUnitRepositories().Get(entity.Business_Unit_Code.Value);
            }

            if (entity.category == null)
            {
                entity.category = new CategoryRepositories().Get(entity.Category_Code.Value);
            }

            if (entity.vendor_contact == null)
            {
                entity.vendor_contact = new Vendor_ContactsRepositories().Get(entity.Vendor_Contacts_Code.Value);
            }

            if (entity.Licensors.Count() > 0)
            {
                entity.Licensors.ToList().ForEach(i =>
                {
                    if (i.licensor == null)
                    {
                        i.licensor = new VendorRepositories().Get(i.Vendor_Code.Value);
                    }
                });
            }

            //if (entity.DealTitles.Count() > 0)
            //{
            //    entity.DealTitles.ToList().ForEach(i =>
            //    {
            //        if (i.Title == null)
            //        {
            //            i.Title = new TitleRepositories().GetById(i.Title_Code.Value);
            //        }
            //    });
            //}

            return entity;
        }

        public IEnumerable<Acq_Deal> GetAll()
        {
            var entity = base.GetAll<Acq_Deal, Acq_Deal_Licensor, Acq_Deal_Movie, Deal_Tag, Role, Deal_Type, Entity>();
            entity.ToList().ForEach(i =>
            {
                if (i.primary_vendor == null)
                {
                    i.primary_vendor = new VendorRepositories().Get(i.Vendor_Code.Value);
                }

                if (i.Currency == null)
                {
                    i.Currency = new CurrencyRepositories().Get(i.Currency_Code.Value);
                }

                if (i.business_unit == null)
                {
                    i.business_unit = new BusinessUnitRepositories().Get(i.Business_Unit_Code.Value);
                }

                if (i.category == null)
                {
                    i.category = new CategoryRepositories().Get(i.Category_Code.Value);
                }

                if (i.vendor_contact == null)
                {
                    i.vendor_contact = new Vendor_ContactsRepositories().Get(i.Vendor_Contacts_Code.Value);
                }

                if (i.Licensors.Count() > 0)
                {
                    i.Licensors.ToList().ForEach(j =>
                    {
                        if (j.licensor == null)
                        {
                            j.licensor = new VendorRepositories().Get(j.Vendor_Code.Value);
                        }
                    });
                }

                //if (i.DealTitles.Count() > 0)
                //{
                //    i.DealTitles.ToList().ForEach(j =>
                //    {
                //        if (j.Title == null)
                //        {
                //            j.Title = new TitleRepositories().GetById(j.Title_Code.Value);
                //        }
                //    });
                //}
            });

            return entity;
        }

        public void Add(Acq_Deal entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal entity)
        {
            Acq_Deal oldObj = GetById(entity.Acq_Deal_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal> SearchFor(object param)
        {
            var entity = base.SearchForEntity<Acq_Deal, Acq_Deal_Licensor, Acq_Deal_Movie, Deal_Tag, Role, Deal_Type, Entity>(param);
            entity.ToList().ForEach(i =>
            {
                if (i.primary_vendor == null)
                {
                    i.primary_vendor = new VendorRepositories().Get(i.Vendor_Code.Value);
                }

                if (i.Currency == null)
                {
                    i.Currency = new CurrencyRepositories().Get(i.Currency_Code.Value);
                }

                if (i.business_unit == null)
                {
                    i.business_unit = new BusinessUnitRepositories().Get(i.Business_Unit_Code.Value);
                }

                if (i.category == null)
                {
                    i.category = new CategoryRepositories().Get(i.Category_Code.Value);
                }

                if (i.vendor_contact == null)
                {
                    i.vendor_contact = new Vendor_ContactsRepositories().Get(i.Vendor_Contacts_Code.Value);
                }

                if (i.Licensors.Count() > 0)
                {
                    i.Licensors.ToList().ForEach(j =>
                    {
                        if (j.licensor == null)
                        {
                            j.licensor = new VendorRepositories().Get(j.Vendor_Code.Value);
                        }
                    });
                }

                //if (i.DealTitles.Count() > 0)
                //{
                //    i.DealTitles.ToList().ForEach(j =>
                //    {
                //        if (j.Title == null)
                //        {
                //            j.Title = new TitleRepositories().GetById(j.Title_Code.Value);
                //        }
                //    });
                //}

            });

            return entity;
        }

        public IEnumerable<Acq_Deal> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal>(strSQL);
        }
    }
}
