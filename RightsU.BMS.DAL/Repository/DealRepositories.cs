﻿using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.DAL.Repository
{
    public class DealRepositories : MainRepository<Acq_Deal>
    {
        public Acq_Deal Get(int Id)
        {
            var obj = new { Acq_Deal_Code = Id };
            var entity = base.GetById<Acq_Deal, Acq_Deal_Licensor, Acq_Deal_Movie, Vendor, Deal_Type, Deal_Tag, Role>(obj);

            if (entity != null)
            {
                if (entity.primary_vendor == null && (entity.Vendor_Code != null || entity.Vendor_Code > 0))
                {
                    entity.primary_vendor = new VendorRepositories().Get(entity.Vendor_Code.Value);
                }

                if (entity.Currency == null && (entity.Currency_Code != null || entity.Currency_Code > 0))
                {
                    entity.Currency = new CurrencyRepositories().Get(entity.Currency_Code.Value);
                }

                if (entity.business_unit == null && (entity.Business_Unit_Code != null || entity.Business_Unit_Code > 0))
                {
                    entity.business_unit = new BusinessUnitRepositories().Get(entity.Business_Unit_Code.Value);
                }

                if (entity.category == null && (entity.Category_Code != null || entity.Category_Code > 0))
                {
                    entity.category = new CategoryRepositories().Get(entity.Category_Code.Value);
                }

                if (entity.vendor_contact == null && (entity.Vendor_Contacts_Code != null || entity.Vendor_Contacts_Code > 0))
                {
                    entity.vendor_contact = new Vendor_ContactsRepositories().Get(entity.Vendor_Contacts_Code.Value);
                }

                if (entity.entity == null && (entity.Entity_Code != null || entity.Entity_Code > 0))
                {
                    entity.entity = new EntityRepositories().Get(entity.Entity_Code.Value);
                }

                //if (entity.licensors.Count() > 0)
                //{
                //    entity.licensors.ToList().ForEach(i =>
                //    {
                //        if (i.vendor == null)
                //        {
                //            i.vendor = new VendorRepositories().Get(i.Vendor_Code.Value);
                //        }
                //    });
                //}
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
            var entity = base.GetAll<Acq_Deal, Acq_Deal_Licensor, Acq_Deal_Movie, Vendor, Deal_Type, Deal_Tag, Role>();
            entity.ToList().ForEach(i =>
            {
                if (i.primary_vendor == null && (i.Vendor_Code != null || i.Vendor_Code > 0))
                {
                    i.primary_vendor = new VendorRepositories().Get(i.Vendor_Code.Value);
                }

                if (i.Currency == null && (i.Currency_Code != null || i.Currency_Code > 0))
                {
                    i.Currency = new CurrencyRepositories().Get(i.Currency_Code.Value);
                }

                if (i.business_unit == null && (i.Business_Unit_Code != null || i.Business_Unit_Code > 0))
                {
                    i.business_unit = new BusinessUnitRepositories().Get(i.Business_Unit_Code.Value);
                }

                if (i.category == null && (i.Category_Code != null || i.Category_Code > 0))
                {
                    i.category = new CategoryRepositories().Get(i.Category_Code.Value);
                }

                if (i.vendor_contact == null && (i.Vendor_Contacts_Code != null || i.Vendor_Contacts_Code > 0))
                {
                    i.vendor_contact = new Vendor_ContactsRepositories().Get(i.Vendor_Contacts_Code.Value);
                }

                if (i.entity == null && (i.Entity_Code != null || i.Entity_Code > 0))
                {
                    i.entity = new EntityRepositories().Get(i.Entity_Code.Value);
                }

                //if (i.licensors.Count() > 0)
                //{
                //    i.licensors.ToList().ForEach(j =>
                //    {
                //        if (j.vendor == null)
                //        {
                //            j.vendor = new VendorRepositories().Get(j.Vendor_Code.Value);
                //        }
                //    });
                //}

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
            Acq_Deal oldObj = Get(entity.Acq_Deal_Code.Value);
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

                if (i.licensors.Count() > 0)
                {
                    i.licensors.ToList().ForEach(j =>
                    {
                        if (j.vendor == null)
                        {
                            j.vendor = new VendorRepositories().Get(j.Vendor_Code.Value);
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

    #region -------- Acq_Deal_Licensor -----------
    public class Acq_Deal_LicensorRepositories : MainRepository<Acq_Deal_Licensor>
    {
        public Acq_Deal_Licensor Get(int Id)
        {
            var obj = new { Acq_Deal_Licensor_Code = Id };

            return base.GetById<Acq_Deal_Licensor>(obj);
        }
        public IEnumerable<Acq_Deal_Licensor> GetAll()
        {
            return base.GetAll<Acq_Deal_Licensor>();
        }
        public void Add(Acq_Deal_Licensor entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Licensor entity)
        {
            Acq_Deal_Licensor oldObj = Get(entity.Acq_Deal_Licensor_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Licensor entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Licensor> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Licensor>(param);
        }

        public IEnumerable<Acq_Deal_Licensor> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Licensor>(strSQL);
        }
    }
    #endregion

    #region -------- Acq_Deal_Movie -----------
    public class Acq_Deal_MovieRepositories : MainRepository<Acq_Deal_Movie>
    {
        public Acq_Deal_Movie Get(int Id)
        {
            var obj = new { Acq_Deal_Movie_Code = Id };

            return base.GetById<Acq_Deal_Movie>(obj);
        }
        public IEnumerable<Acq_Deal_Movie> GetAll()
        {
            return base.GetAll<Acq_Deal_Movie>();
        }
        public void Add(Acq_Deal_Movie entity)
        {
            base.AddEntity(entity);
        }

        public void Update(Acq_Deal_Movie entity)
        {
            Acq_Deal_Movie oldObj = Get(entity.Acq_Deal_Movie_Code.Value);
            base.UpdateEntity(oldObj, entity);
        }

        public void Delete(Acq_Deal_Movie entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Acq_Deal_Movie> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Movie>(param);
        }

        public IEnumerable<Acq_Deal_Movie> GetDataWithSQLStmt(string strSQL)
        {
            return base.ExecuteSQLStmt<Acq_Deal_Movie>(strSQL);
        }
    }
    #endregion
}