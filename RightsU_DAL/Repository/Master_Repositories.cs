using RightsU_Entities;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Data.Entity.Core;
using System.Data.Entity.Core.Objects;
using System;
using System.Linq.Expressions;

namespace RightsU_DAL
{
    public class Ancillary_Medium_Repository : RightsU_Repository<Ancillary_Medium>
    {
        public Ancillary_Medium_Repository(string conStr) : base(conStr) { }
    }

    public class Ancillary_Type_Repository : RightsU_Repository<Ancillary_Type>
    {
        public Ancillary_Type_Repository(string conStr) : base(conStr) { }
    }

    public class Ancillary_Platform_Repository : RightsU_Repository<Ancillary_Platform>
    {
        public Ancillary_Platform_Repository(string conStr) : base(conStr) { }
    }

    public class Ancillary_Platform_Medium_Repository : RightsU_Repository<Ancillary_Platform_Medium>
    {
        public Ancillary_Platform_Medium_Repository(string conStr) : base(conStr) { }
    }

    public class Language_Repository : RightsU_Repository<Language>
    {
        public Language_Repository(string conStr) : base(conStr) { }

        public override void Save(Language objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Language objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Language_Group_Repository : RightsU_Repository<Language_Group>
    {
        public Language_Group_Repository(string conStr) : base(conStr) { }

        public override void Save(Language_Group objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Language_Group_Details != null) objToSave.Language_Group_Details = objSaveEntities.SaveLanguageGroupDetails(objToSave.Language_Group_Details, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Language_Group objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Title_Repository : RightsU_Repository<Title>
    {
        public Title_Repository(string conStr) : base(conStr) { }
        public override void Save(Title objTitle)
        {
            Save_Title_Entities_Generic objSaveEntities = new Save_Title_Entities_Generic();

            if (objTitle.Title_Talent != null) objTitle.Title_Talent = objSaveEntities.SaveTalent(objTitle.Title_Talent, base.DataContext);
            if (objTitle.Title_Geners != null) objTitle.Title_Geners = objSaveEntities.SaveGenre(objTitle.Title_Geners, base.DataContext);
            if (objTitle.Title_Country != null) objTitle.Title_Country = objSaveEntities.SaveCountry(objTitle.Title_Country, base.DataContext);

            if (objTitle.EntityState == State.Added)
            {
                base.Save(objTitle);
            }
            else if (objTitle.EntityState == State.Modified)
            {
                base.Update(objTitle);
            }
            else if (objTitle.EntityState == State.Deleted)
            {
                base.Delete(objTitle);
            }
        }
        public override void Delete(Title objTitle)
        {
            base.Delete(objTitle);
        }
    }

    public class Save_Title_Entities_Generic
    {
        public ICollection<Title_Talent> SaveTalent(ICollection<Title_Talent> entityTitles, DbContext dbContext)
        {
            ICollection<Title_Talent> UpdatedTalents = entityTitles;

            UpdatedTalents = new Save_Entitiy_Lists_Generic<Title_Talent>().SetListFlagsCUD(UpdatedTalents, dbContext);

            return UpdatedTalents;
        }

        public ICollection<Title_Geners> SaveGenre(ICollection<Title_Geners> entityTitles, DbContext dbContext)
        {
            ICollection<Title_Geners> UpdatedGenre = entityTitles;

            UpdatedGenre = new Save_Entitiy_Lists_Generic<Title_Geners>().SetListFlagsCUD(UpdatedGenre, dbContext);

            return UpdatedGenre;
        }

        public ICollection<Title_Country> SaveCountry(ICollection<Title_Country> entityTitles, DbContext dbContext)
        {
            ICollection<Title_Country> UpdatedGenre = entityTitles;

            UpdatedGenre = new Save_Entitiy_Lists_Generic<Title_Country>().SetListFlagsCUD(UpdatedGenre, dbContext);

            return UpdatedGenre;
        }
    }

    public class Save_Map_Extended_Details_Generic
    {
        public ICollection<Map_Extended_Columns_Details> SaveMapExtendedColumnsDetails(ICollection<Map_Extended_Columns_Details> entityTitles, DbContext dbContext)
        {
            ICollection<Map_Extended_Columns_Details> UpdatedTalents = entityTitles;

            UpdatedTalents = new Save_Entitiy_Lists_Generic<Map_Extended_Columns_Details>().SetListFlagsCUD(UpdatedTalents, dbContext);

            return UpdatedTalents;
        }
    }


    public class Country_Repository : RightsU_Repository<Country>
    {
        public Country_Repository(string conStr) : base(conStr) { }

        public override void Save(Country objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Country_Language != null) objToSave.Country_Language = objSaveEntities.SaveCountryLanguage(objToSave.Country_Language, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Country objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Country_Language_Repository : RightsU_Repository<Country_Language>
    {
        public Country_Language_Repository(string conStr) : base(conStr) { }

        public override void Save(Country_Language objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Country_Language objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Title_Release_Repository : RightsU_Repository<Title_Release>
    {
        public Title_Release_Repository(string conStr) : base(conStr) { }

        public override void Delete(Title_Release obj)
        {
            base.Delete(obj);
        }
    }

    public class Title_Release_Platform_Repository : RightsU_Repository<Title_Release_Platforms>
    {
        public Title_Release_Platform_Repository(string conStr) : base(conStr) { }
    }

    public class Title_Release_Region_Repository : RightsU_Repository<Title_Release_Region>
    {
        public Title_Release_Region_Repository(string conStr) : base(conStr) { }
    }

    public class Territory_Repository : RightsU_Repository<Territory>
    {
        public Territory_Repository(string conStr) : base(conStr) { }

        public override void Save(Territory objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Territory_Details != null) objToSave.Territory_Details = objSaveEntities.SaveTerritoryDetails(objToSave.Territory_Details, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Territory objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Platform_Repository : RightsU_Repository<Platform>
    {
        public Platform_Repository(string conStr) : base(conStr) { }
    }

    public class Vendor_Repository : RightsU_Repository<Vendor>
    {
        public Vendor_Repository(string conStr) : base(conStr) { }

        public override void Save(Vendor objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Vendor_Contacts != null) objToSave.Vendor_Contacts = objSaveEntities.SaveVendorContact(objToSave.Vendor_Contacts, base.DataContext);
            if (objToSave.Vendor_Role != null) objToSave.Vendor_Role = objSaveEntities.SaveVendorRole(objToSave.Vendor_Role, base.DataContext);
            if (objToSave.Vendor_Country != null) objToSave.Vendor_Country = objSaveEntities.SaveVendorCountry(objToSave.Vendor_Country, base.DataContext);
            if (objToSave.AL_Vendor_Rule != null) objToSave.AL_Vendor_Rule = objSaveEntities.SaveVendorRule(objToSave.AL_Vendor_Rule, base.DataContext);
            if (objToSave.AL_Vendor_OEM != null) objToSave.AL_Vendor_OEM = objSaveEntities.SaveVendorOEM(objToSave.AL_Vendor_OEM, base.DataContext);
            if (objToSave.AL_Vendor_TnC != null) objToSave.AL_Vendor_TnC = objSaveEntities.SaveVendorTnC(objToSave.AL_Vendor_TnC, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Vendor objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Channel_Repository : RightsU_Repository<Channel>
    {
        public Channel_Repository(string conStr) : base(conStr) { }

        public override void Save(Channel objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Channel_Territory != null) objToSave.Channel_Territory = objSaveEntities.SaveChannelTerritory(objToSave.Channel_Territory, base.DataContext);
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Channel objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Currency_Repository : RightsU_Repository<Currency>
    {
        public Currency_Repository(string conStr) : base(conStr) { }

        public override void Save(Currency objCurrency)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objCurrency.Currency_Exchange_Rate != null) objCurrency.Currency_Exchange_Rate = objSaveEntities.SaveCurrencyExchangeRate(objCurrency.Currency_Exchange_Rate, base.DataContext);

            if (objCurrency.EntityState == State.Added)
            {
                base.Save(objCurrency);
            }
            else if (objCurrency.EntityState == State.Modified)
            {
                base.Update(objCurrency);
            }
            else if (objCurrency.EntityState == State.Deleted)
            {
                base.Delete(objCurrency);
            }
        }
    }

    public class Additional_Expense_Repository : RightsU_Repository<Additional_Expense>
    {
        public Additional_Expense_Repository(string conStr) : base(conStr) { }

        public override void Save(Additional_Expense objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Additional_Expense objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Cost_Type_Repository : RightsU_Repository<Cost_Type>
    {
        public Cost_Type_Repository(string conStr) : base(conStr) { }

        public override void Save(Cost_Type objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Cost_Type objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Payment_Terms_Repository : RightsU_Repository<Payment_Terms>
    {
        public Payment_Terms_Repository(string conStr) : base(conStr) { }

        public override void Save(Payment_Terms objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Payment_Terms objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Milestone_Type_Repository : RightsU_Repository<Milestone_Type>
    {
        public Milestone_Type_Repository(string conStr) : base(conStr) { }
    }

    public class Users_Business_Unit_Repository : RightsU_Repository<Users_Business_Unit>
    {
        public Users_Business_Unit_Repository(string conStr) : base(conStr) { }
        public override void Save(Users_Business_Unit objUsers_Business_Unit)
        {
            if (objUsers_Business_Unit.EntityState == State.Added)
            {
                base.Save(objUsers_Business_Unit);
            }
            else if (objUsers_Business_Unit.EntityState == State.Modified)
            {
                base.Update(objUsers_Business_Unit);
            }
            else if (objUsers_Business_Unit.EntityState == State.Deleted)
            {
                base.Delete(objUsers_Business_Unit);
            }
        }
    }
    public class Acq_Deal_Rights_Promoter_Group_Repository : RightsU_Repository<Acq_Deal_Rights_Promoter_Group>
    {
        public Acq_Deal_Rights_Promoter_Group_Repository(string conStr) : base(conStr) { }
    }
    public class Acq_Deal_Rights_Promoter_Remarks_Repository : RightsU_Repository<Acq_Deal_Rights_Promoter_Remarks>
    {
        public Acq_Deal_Rights_Promoter_Remarks_Repository(string conStr) : base(conStr) { }
    }
    public class Deal_Type_Repository : RightsU_Repository<Deal_Type>
    {
        public Deal_Type_Repository(string conStr) : base(conStr) { }
    }

    public class Deal_Tag_Repository : RightsU_Repository<Deal_Tag>
    {
        public Deal_Tag_Repository(string conStr) : base(conStr) { }
    }

    public class Sub_License_Repository : RightsU_Repository<Sub_License>
    {
        public Sub_License_Repository(string conStr) : base(conStr) { }
    }

    public class Royalty_Recoupment_Repository : RightsU_Repository<Royalty_Recoupment>
    {
        public Royalty_Recoupment_Repository(string conStr) : base(conStr) { }

        public override void Save(Royalty_Recoupment objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Royalty_Recoupment_Details != null) objToSave.Royalty_Recoupment_Details = objSaveEntities.SaveRoyaltyRecoupmentDetails(objToSave.Royalty_Recoupment_Details, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Royalty_Recoupment objToDelete)
        {
            base.Delete(objToDelete);
        }

    }

    public class Business_Unit_Repository : RightsU_Repository<Business_Unit>
    {
        public Business_Unit_Repository(string conStr) : base(conStr) { }
        public override void Save(Business_Unit objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
    }
    public class Promoter_Group_Repository : RightsU_Repository<Promoter_Group>
    {
        public Promoter_Group_Repository(string conStr) : base(conStr) { }
    }
    public class Promoter_Remarks_Repository : RightsU_Repository<Promoter_Remarks>
    {
        public Promoter_Remarks_Repository(string conStr) : base(conStr) { }

        public override void Save(Promoter_Remarks objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Promoter_Remarks objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Category_Repository : RightsU_Repository<Category>
    {
        public Category_Repository(string conStr) : base(conStr) { }

        public override void Save(Category objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Category objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Entity_Repository : RightsU_Repository<Entity>
    {
        public Entity_Repository(string conStr) : base(conStr) { }
        public override void Save(Entity objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
    }

    public class Territory_Details_Repository : RightsU_Repository<Territory_Details>
    {
        public Territory_Details_Repository(string conStr) : base(conStr) { }
    }

    public class Vendor_Contacts_Repository : RightsU_Repository<Vendor_Contacts>
    {
        public Vendor_Contacts_Repository(string conStr) : base(conStr) { }
    }

    public class Right_Rule_Repository : RightsU_Repository<Right_Rule>
    {
        public Right_Rule_Repository(string conStr) : base(conStr) { }

        public override void Save(Right_Rule objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Right_Rule objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Material_Medium_Repository : RightsU_Repository<Material_Medium>
    {
        public Material_Medium_Repository(string conStr) : base(conStr) { }

        public override void Save(Material_Medium objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Material_Medium objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Material_Type_Repository : RightsU_Repository<Material_Type>
    {
        public Material_Type_Repository(string conStr) : base(conStr) { }

        public override void Save(Material_Type objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Material_Type objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Role_Repository : RightsU_Repository<Role>
    {
        public Role_Repository(string conStr) : base(conStr) { }
    }

    public class System_Parameter_New_Repository : RightsU_Repository<System_Parameter_New>
    {
        public System_Parameter_New_Repository(string conStr) : base(conStr) { }

        public override void Save(System_Parameter_New objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(System_Parameter_New objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Document_Type_Repository : RightsU_Repository<Document_Type>
    {
        public Document_Type_Repository(string conStr) : base(conStr) { }

        public override void Save(Document_Type objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Document_Type objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Module_Status_History_Type_Repository : RightsU_Repository<Module_Status_History>
    {
        public Module_Status_History_Type_Repository(string conStr) : base(conStr) { }

        public override void Save(Module_Status_History objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Module_Status_History objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class User_Repository : RightsU_Repository<User>
    {
        public User_Repository(string conStr) : base(conStr) { }
        public override void Save(User objUser)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objUser.Users_Business_Unit != null) objUser.Users_Business_Unit = objSaveEntities.SaveUserBusinessUnit(objUser.Users_Business_Unit, base.DataContext);
            if (objUser.MHUsers != null) objUser.MHUsers = objSaveEntities.SaveMHUser(objUser.MHUsers, base.DataContext);
            if (objUser.Users_Configuration != null) objUser.Users_Configuration = objSaveEntities.SaveUserConfiguration(objUser.Users_Configuration, base.DataContext);
            if (objUser.Users_Exclusion_Rights != null) objUser.Users_Exclusion_Rights = objSaveEntities.SaveUserExclusionRights(objUser.Users_Exclusion_Rights, base.DataContext);
            if (objUser.Users_Detail != null) objUser.Users_Detail = objSaveEntities.SaveUserUsers_Detail(objUser.Users_Detail, base.DataContext);


            if (objUser.EntityState == State.Added)
            {
                base.Save(objUser);
            }
            else if (objUser.EntityState == State.Modified)
            {
                base.Update(objUser);
            }
            else if (objUser.EntityState == State.Deleted)
            {
                base.Delete(objUser);
            }
        }
        public override void Delete(User objADRS)
        {
            base.Delete(objADRS);
        }
    }
    public class SAP_WBS_Repository : RightsU_Repository<SAP_WBS>
    {
        public SAP_WBS_Repository(string conStr) : base(conStr) { }

        public override void Save(SAP_WBS objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(SAP_WBS objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class SAP_Export_Repository : RightsU_Repository<SAP_Export>
    {
        public SAP_Export_Repository(string conStr) : base(conStr) { }

        public override void Save(SAP_Export objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(SAP_Export objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Monetisation_Type_Repository : RightsU_Repository<Monetisation_Type>
    {
        public Monetisation_Type_Repository(string conStr) : base(conStr) { }
    }

    public class Sponsor_Repository : RightsU_Repository<Sponsor>
    {
        public Sponsor_Repository(string conStr) : base(conStr) { }

        public override void Save(Sponsor objSAS)
        {
            if (objSAS.EntityState == State.Added)
            {
                base.Save(objSAS);
            }
            else if (objSAS.EntityState == State.Modified)
            {
                base.Update(objSAS);
            }
            else if (objSAS.EntityState == State.Deleted)
            {
                base.Delete(objSAS);
            }
        }

        public override void Delete(Sponsor objADRS)
        {
            base.Delete(objADRS);
        }
    }

    public class Sport_Ancillary_Broadcast_Repository : RightsU_Repository<Sport_Ancillary_Broadcast>
    {
        public Sport_Ancillary_Broadcast_Repository(string conStr) : base(conStr) { }
    }

    public class Module_Workflow_Detail_Repository : RightsU_Repository<Module_Workflow_Detail>
    {
        public Module_Workflow_Detail_Repository(string conStr) : base(conStr) { }
    }

    public class Sport_Ancillary_Config_Repository : RightsU_Repository<Sport_Ancillary_Config>
    {
        public Sport_Ancillary_Config_Repository(string conStr) : base(conStr) { }
    }

    public class Sport_Ancillary_Periodicity_Repository : RightsU_Repository<Sport_Ancillary_Periodicity>
    {
        public Sport_Ancillary_Periodicity_Repository(string conStr) : base(conStr) { }
    }

    public class Sport_Ancillary_Source_Repository : RightsU_Repository<Sport_Ancillary_Source>
    {
        public Sport_Ancillary_Source_Repository(string conStr) : base(conStr) { }
    }

    public class Sport_Ancillary_Type_Repository : RightsU_Repository<Sport_Ancillary_Type>
    {
        public Sport_Ancillary_Type_Repository(string conStr) : base(conStr) { }
    }

    public class Broadcast_Mode_Repository : RightsU_Repository<Broadcast_Mode>
    {
        public Broadcast_Mode_Repository(string conStr) : base(conStr) { }
    }
    public class BV_HouseId_Data_Repository : RightsU_Repository<BV_HouseId_Data>
    {
        public BV_HouseId_Data_Repository(string conStr) : base(conStr) { }
    }
    public class Users_Password_Detail_Repository : RightsU_Repository<Users_Password_Detail>
    {
        public Users_Password_Detail_Repository(string conStr) : base(conStr) { }

        public override void Save(Users_Password_Detail objUPD)
        {
            if (objUPD.EntityState == State.Added)
            {
                base.Save(objUPD);
            }
            else if (objUPD.EntityState == State.Modified)
            {
                base.Update(objUPD);
            }
            else if (objUPD.EntityState == State.Deleted)
            {
                base.Delete(objUPD);
            }
        }

        public override void Delete(Users_Password_Detail objUPD)
        {
            base.Delete(objUPD);
        }
    }

    public class Talent_Repository : RightsU_Repository<Talent>
    {
        public Talent_Repository(string conStr) : base(conStr) { }

        public override void Save(Talent objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Talent_Role != null) objToSave.Talent_Role = objSaveEntities.SaveTalentRole(objToSave.Talent_Role, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Talent objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Talent_Role_Repository : RightsU_Repository<Talent_Role>
    {
        public Talent_Role_Repository(string conStr) : base(conStr) { }
    }
    public class Genre_Repository : RightsU_Repository<Genre>
    {
        public Genre_Repository(string conStr) : base(conStr) { }

        public override void Save(Genre objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Genre objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Deal_Description_Repository : RightsU_Repository<Deal_Description>
    {
        public Deal_Description_Repository(string conStr) : base(conStr) { }

        public override void Save(Deal_Description objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Deal_Description objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Objection_Type_Repository : RightsU_Repository<Title_Objection_Type>
    {
        public Objection_Type_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Objection_Type objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Title_Objection_Type objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Extended_Columns_Repository : RightsU_Repository<Extended_Columns>
    {
        public Extended_Columns_Repository(string conStr) : base(conStr) { }
        public override void Save(Extended_Columns objEC)
        {
            if (objEC.EntityState == State.Added)
            {
                base.Save(objEC);
            }
            else if (objEC.EntityState == State.Modified)
            {
                base.Update(objEC);
            }
            else if (objEC.EntityState == State.Deleted)
            {
                base.Delete(objEC);
            }
        }
        public override void Delete(Extended_Columns objEC)
        {
            base.Delete(objEC);
        }
    }
    public class Extended_Columns_Value_Repository : RightsU_Repository<Extended_Columns_Value>
    {
        public Extended_Columns_Value_Repository(string conStr) : base(conStr) { }
        public override void Save(Extended_Columns_Value objEV)
        {
            if (objEV.EntityState == State.Added)
            {
                base.Save(objEV);
            }
            else if (objEV.EntityState == State.Modified)
            {
                base.Update(objEV);
            }
            else if (objEV.EntityState == State.Deleted)
            {
                base.Delete(objEV);
            }
        }
        public override void Delete(Extended_Columns_Value objEV)
        {
            base.Delete(objEV);
        }
    }

    public class Map_Extended_Columns_Repository : RightsU_Repository<Map_Extended_Columns>
    {
        public Map_Extended_Columns_Repository(string conStr) : base(conStr) { }


        public override void Save(Map_Extended_Columns objUPD)
        {
            Save_Map_Extended_Details_Generic objSaveEntities = new Save_Map_Extended_Details_Generic();

            if (objUPD.Map_Extended_Columns_Details != null) objUPD.Map_Extended_Columns_Details = objSaveEntities.SaveMapExtendedColumnsDetails(objUPD.Map_Extended_Columns_Details, base.DataContext);


            if (objUPD.EntityState == State.Added)
            {
                base.Save(objUPD);
            }
            else if (objUPD.EntityState == State.Modified)
            {
                base.Update(objUPD);
            }
            else if (objUPD.EntityState == State.Deleted)
            {
                base.Delete(objUPD);
            }
        }

        public override void Delete(Map_Extended_Columns objUPD)
        {
            base.Delete(objUPD);
        }

    }

    public class ROFR_Repository : RightsU_Repository<ROFR>
    {
        public ROFR_Repository(string conStr) : base(conStr) { }
    }

    public class Channel_Cluster_Repository : RightsU_Repository<Channel_Cluster>
    {
        public Channel_Cluster_Repository(string conStr) : base(conStr) { }
    }

    public class WBS_Type_Repository : RightsU_Repository<WBS_Type>
    {
        public WBS_Type_Repository(string conStr) : base(conStr) { }
    }

    public class Platform_Group_Repository : RightsU_Repository<Platform_Group>
    {
        public Platform_Group_Repository(string conStr) : base(conStr) { }

        public override void Save(Platform_Group obj)
        {
            Save_Platform_Group_Generic objSaveEntities = new Save_Platform_Group_Generic();

            if (obj.Platform_Group_Details != null) obj.Platform_Group_Details = objSaveEntities.SavePlatformGroupDetails(obj.Platform_Group_Details, base.DataContext);

            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

        public override void Delete(Platform_Group obj)
        {
            base.Delete(obj);
        }
    }

    public class Platform_Group_Details_Repository : RightsU_Repository<Platform_Group_Details>
    {
        public Platform_Group_Details_Repository(string conStr) : base(conStr) { }

        public override void Save(Platform_Group_Details obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

        public override void Delete(Platform_Group_Details obj)
        {
            base.Delete(obj);
        }
    }

    public class Channel_Region_Repository : RightsU_Repository<Channel_Region>
    {
        public Channel_Region_Repository(string conStr) : base(conStr) { }
    }

    public class Channel_Region_Mapping_Repository : RightsU_Repository<Channel_Region_Mapping>
    {
        public Channel_Region_Mapping_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Label_Repository : RightsU_Repository<Music_Label>
    {
        public Music_Label_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Label objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Music_Label objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Music_Title_Repository : RightsU_Repository<Music_Title>
    {
        public Music_Title_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Title objTitle)
        {
            Save_Music_Title_Entities_Generic objSaveEntities = new Save_Music_Title_Entities_Generic();

            if (objTitle.Music_Title_Talent != null) objTitle.Music_Title_Talent = objSaveEntities.SaveTalent(objTitle.Music_Title_Talent, base.DataContext);
            if (objTitle.Music_Title_Label != null) objTitle.Music_Title_Label = objSaveEntities.SaveMusicLabel(objTitle.Music_Title_Label, base.DataContext);
            if (objTitle.Music_Title_Language != null) objTitle.Music_Title_Language = objSaveEntities.SaveMusicTitleLanguage(objTitle.Music_Title_Language, base.DataContext);
            if (objTitle.Music_Title_Theme != null) objTitle.Music_Title_Theme = objSaveEntities.SaveMusicTitleTheme(objTitle.Music_Title_Theme, base.DataContext);

            if (objTitle.EntityState == State.Added)
            {
                base.Save(objTitle);
            }
            else if (objTitle.EntityState == State.Modified)
            {
                base.Update(objTitle);
            }
            else if (objTitle.EntityState == State.Deleted)
            {
                base.Delete(objTitle);
            }
        }
        public override void Delete(Music_Title objTitle)
        {
            base.Delete(objTitle);
        }
    }

    public class Save_Music_Title_Entities_Generic
    {
        public ICollection<Music_Title_Talent> SaveTalent(ICollection<Music_Title_Talent> entityTitles, DbContext dbContext)
        {
            ICollection<Music_Title_Talent> UpdatedTalents = entityTitles;

            UpdatedTalents = new Save_Entitiy_Lists_Generic<Music_Title_Talent>().SetListFlagsCUD(UpdatedTalents, dbContext);

            return UpdatedTalents;
        }

        public ICollection<Music_Title_Label> SaveMusicLabel(ICollection<Music_Title_Label> entityTitles, DbContext dbContext)
        {
            ICollection<Music_Title_Label> UpdatedGenre = entityTitles;

            UpdatedGenre = new Save_Entitiy_Lists_Generic<Music_Title_Label>().SetListFlagsCUD(UpdatedGenre, dbContext);

            return UpdatedGenre;
        }
        public ICollection<Music_Title_Language> SaveMusicTitleLanguage(ICollection<Music_Title_Language> entityTitles, DbContext dbContext)
        {
            ICollection<Music_Title_Language> UpdatedLanguage = entityTitles;

            UpdatedLanguage = new Save_Entitiy_Lists_Generic<Music_Title_Language>().SetListFlagsCUD(UpdatedLanguage, dbContext);

            return UpdatedLanguage;
        }
        public ICollection<Music_Title_Theme> SaveMusicTitleTheme(ICollection<Music_Title_Theme> entityTitles, DbContext dbContext)
        {
            ICollection<Music_Title_Theme> UpdatedTheme = entityTitles;

            UpdatedTheme = new Save_Entitiy_Lists_Generic<Music_Title_Theme>().SetListFlagsCUD(UpdatedTheme, dbContext);

            return UpdatedTheme;
        }
    }

    public class Music_Title_Label_Repository : RightsU_Repository<Music_Title_Label>
    {
        public Music_Title_Label_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Title_Talent_Repository : RightsU_Repository<Music_Title_Talent>
    {
        public Music_Title_Talent_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Type_Repository : RightsU_Repository<Music_Type>
    {
        public Music_Type_Repository(string conStr) : base(conStr) { }
    }

    public class Save_Platform_Group_Generic
    {
        public ICollection<Platform_Group_Details> SavePlatformGroupDetails(ICollection<Platform_Group_Details> entityAttachment, DbContext dbContext)
        {
            ICollection<Platform_Group_Details> updatedCollection = entityAttachment;
            updatedCollection = new Save_Entitiy_Lists_Generic<Platform_Group_Details>().SetListFlagsCUD(updatedCollection, dbContext);
            return updatedCollection;
        }

        public void DeletePlatformGroupDetails(ICollection<Platform_Group_Details> deleteList, RightsU_NeoEntities dbContext)
        {
            dbContext.Platform_Group_Details.RemoveRange(deleteList);
        }
    }

    public class Amort_Rule_Repository : RightsU_Repository<Amort_Rule>
    {
        public Amort_Rule_Repository(string conStr) : base(conStr) { }

        public override void Save(Amort_Rule objAmortRule)
        {
            Save_Amort_Rule_Entities_Generic objSaveEntities = new Save_Amort_Rule_Entities_Generic();
            if (objAmortRule.Amort_Rule_Details != null) objAmortRule.Amort_Rule_Details = objSaveEntities.SaveAmortDetails(objAmortRule.Amort_Rule_Details, base.DataContext);

            if (objAmortRule.EntityState == State.Added)
            {
                base.Save(objAmortRule);
            }
            else if (objAmortRule.EntityState == State.Modified)
            {
                base.Update(objAmortRule);
            }
            else if (objAmortRule.EntityState == State.Deleted)
            {
                base.Delete(objAmortRule);
            }
        }
        public override void Delete(Amort_Rule objAmortRule)
        {
            base.Delete(objAmortRule);
        }
    }

    public class Save_Amort_Rule_Entities_Generic
    {

        public ICollection<Amort_Rule_Details> SaveAmortDetails(ICollection<Amort_Rule_Details> entityTitles, DbContext dbContext)
        {
            ICollection<Amort_Rule_Details> UpdatedGenre = entityTitles;

            UpdatedGenre = new Save_Entitiy_Lists_Generic<Amort_Rule_Details>().SetListFlagsCUD(UpdatedGenre, dbContext);

            return UpdatedGenre;
        }
    }

    public class Amort_Rule_Details_Repository : RightsU_Repository<Amort_Rule_Details>
    {
        public Amort_Rule_Details_Repository(string conStr) : base(conStr) { }
    }
    public class Glossary_Repository : RightsU_Repository<Glossary>
    {
        public Glossary_Repository(string conStr) : base(conStr) { }

        public override void Save(Glossary objGlossary)
        {
            if (objGlossary.EntityState == State.Added)
            {
                base.Save(objGlossary);
            }
            else if (objGlossary.EntityState == State.Modified)
            {
                base.Update(objGlossary);
            }
            else if (objGlossary.EntityState == State.Deleted)
            {
                base.Delete(objGlossary);
            }
        }
        public override void Delete(Glossary objGlossary)
        {
            base.Delete(objGlossary);
        }
    }
    public class Glossary_AskExpert_Repository : RightsU_Repository<Glossary_AskExpert>
    {
        public Glossary_AskExpert_Repository(string conStr) : base(conStr) { }

        public override void Save(Glossary_AskExpert objGlossary_AskExpert)
        {
            if (objGlossary_AskExpert.EntityState == State.Added)
            {
                base.Save(objGlossary_AskExpert);
            }
            else if (objGlossary_AskExpert.EntityState == State.Modified)
            {
                base.Update(objGlossary_AskExpert);
            }
            else if (objGlossary_AskExpert.EntityState == State.Deleted)
            {
                base.Delete(objGlossary_AskExpert);
            }
        }
        public override void Delete(Glossary_AskExpert objGlossary_AskExpert)
        {
            base.Delete(objGlossary_AskExpert);
        }
    }

    public class System_Versions_Repository : RightsU_Repository<System_Versions>
    {
        public System_Versions_Repository(string conStr) : base(conStr) { }
    }

    public class Grade_Master_Repository : RightsU_Repository<Grade_Master>
    {
        public Grade_Master_Repository(string conStr) : base(conStr) { }

        public override void Save(Grade_Master objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Grade_Master objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class BVException_Repository : RightsU_Repository<BVException>
    {
        public BVException_Repository(string conStr) : base(conStr) { }

        public override void Save(BVException objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.BVException_Channel != null) objToSave.BVException_Channel = objSaveEntities.SaveBVException_Channel(objToSave.BVException_Channel, base.DataContext);
            if (objToSave.BVException_Users != null) objToSave.BVException_Users = objSaveEntities.SaveBVException_Users(objToSave.BVException_Users, base.DataContext);
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(BVException objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class BVException_Channel_Repository : RightsU_Repository<BVException_Channel>
    {
        public BVException_Channel_Repository(string conStr) : base(conStr) { }

        public override void Save(BVException_Channel objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(BVException_Channel objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class BVException_Users_Repository : RightsU_Repository<BVException_Users>
    {
        public BVException_Users_Repository(string conStr) : base(conStr) { }

        public override void Save(BVException_Users objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(BVException_Users objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Music_Language_Repository : RightsU_Repository<Music_Language>
    {
        public Music_Language_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Language objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Music_Language objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Music_Title_Language_Repository : RightsU_Repository<Music_Title_Language>
    {
        public Music_Title_Language_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Theme_Repository : RightsU_Repository<Music_Theme>
    {
        public Music_Theme_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Theme objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Music_Theme objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Music_Title_Theme_Repository : RightsU_Repository<Music_Title_Theme>
    {
        public Music_Title_Theme_Repository(string conStr) : base(conStr) { }
    }

    public class Music_Album_Repository : RightsU_Repository<Music_Album>
    {
        public Music_Album_Repository(string conStr) : base(conStr) { }

        public override void Save(Music_Album objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();

            if (objToSave.Music_Album_Talent != null) objToSave.Music_Album_Talent = objSaveEntities.SaveMusicAlbumTalent(objToSave.Music_Album_Talent, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Music_Album objToSave)
        {
            base.Delete(objToSave);
        }
    }

    public class Save_Master_Entities_Generic
    {
        public ICollection<Title_Objection_Platform> SaveTitle_Objection_Platform(ICollection<Title_Objection_Platform> entityList, DbContext dbContext)
        {
            ICollection<Title_Objection_Platform> updatedList = entityList;
            updatedList = new Save_Entitiy_Lists_Generic<Title_Objection_Platform>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Title_Objection_Territory> SaveTitle_Objection_Territory(ICollection<Title_Objection_Territory> entityList, DbContext dbContext)
        {
            ICollection<Title_Objection_Territory> updatedList = entityList;
            updatedList = new Save_Entitiy_Lists_Generic<Title_Objection_Territory>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Title_Objection_Rights_Period> SaveTitle_Objection_Rights_Period(ICollection<Title_Objection_Rights_Period> entityList, DbContext dbContext)
        {
            ICollection<Title_Objection_Rights_Period> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Title_Objection_Rights_Period>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Talent_Role> SaveTalentRole(ICollection<Talent_Role> entityList, DbContext dbContext)
        {
            ICollection<Talent_Role> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Talent_Role>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Users_Business_Unit> SaveUserBusinessUnit(ICollection<Users_Business_Unit> entityList, DbContext dbContext)
        {
            ICollection<Users_Business_Unit> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Users_Business_Unit>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<MHUser> SaveMHUser(ICollection<MHUser> entityList, DbContext dbContext)
        {
            ICollection<MHUser> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<MHUser>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Users_Configuration> SaveUserConfiguration(ICollection<Users_Configuration> entityList, DbContext dbContext)
        {
            ICollection<Users_Configuration> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Users_Configuration>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Users_Exclusion_Rights> SaveUserExclusionRights(ICollection<Users_Exclusion_Rights> entityList, DbContext dbContext)
        {
            ICollection<Users_Exclusion_Rights> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Users_Exclusion_Rights>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Currency_Exchange_Rate> SaveCurrencyExchangeRate(ICollection<Currency_Exchange_Rate> entityList, DbContext dbContext)
        {
            ICollection<Currency_Exchange_Rate> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Currency_Exchange_Rate>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Users_Detail> SaveUserUsers_Detail(ICollection<Users_Detail> entityList, DbContext dbContext)
        {
            ICollection<Users_Detail> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Users_Detail>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Vendor_Contacts> SaveVendorContact(ICollection<Vendor_Contacts> entityList, DbContext dbContext)
        {
            ICollection<Vendor_Contacts> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Vendor_Contacts>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Vendor_Role> SaveVendorRole(ICollection<Vendor_Role> entityList, DbContext dbContext)
        {
            ICollection<Vendor_Role> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Vendor_Role>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Vendor_Country> SaveVendorCountry(ICollection<Vendor_Country> entityList, DbContext dbContext)
        {
            ICollection<Vendor_Country> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Vendor_Country>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Language_Group_Details> SaveLanguageGroupDetails(ICollection<Language_Group_Details> entityList, DbContext dbContext)
        {
            ICollection<Language_Group_Details> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Language_Group_Details>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Security_Group_Rel> SaveSecurityGroupRel(ICollection<Security_Group_Rel> entityList, DbContext dbContext)
        {
            ICollection<Security_Group_Rel> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Security_Group_Rel>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Channel_Entity> SaveChannelEntity(ICollection<Channel_Entity> entityList, DbContext dbContext)
        {
            ICollection<Channel_Entity> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Channel_Entity>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Channel_Territory> SaveChannelTerritory(ICollection<Channel_Territory> entityList, DbContext dbContext)
        {
            ICollection<Channel_Territory> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Channel_Territory>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Country_Language> SaveCountryLanguage(ICollection<Country_Language> entityList, DbContext dbContext)
        {
            ICollection<Country_Language> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Country_Language>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Royalty_Recoupment_Details> SaveRoyaltyRecoupmentDetails(ICollection<Royalty_Recoupment_Details> entityList, DbContext dbContext)
        {
            ICollection<Royalty_Recoupment_Details> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Royalty_Recoupment_Details>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<BVException_Channel> SaveBVException_Channel(ICollection<BVException_Channel> entityList, DbContext dbContext)
        {
            ICollection<BVException_Channel> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<BVException_Channel>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<BVException_Users> SaveBVException_Users(ICollection<BVException_Users> entityList, DbContext dbContext)
        {
            ICollection<BVException_Users> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<BVException_Users>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Territory_Details> SaveTerritoryDetails(ICollection<Territory_Details> entityList, DbContext dbContext)
        {
            ICollection<Territory_Details> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Territory_Details>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Music_Album_Talent> SaveMusicAlbumTalent(ICollection<Music_Album_Talent> entityList, DbContext dbContext)
        {
            ICollection<Music_Album_Talent> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Music_Album_Talent>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Workflow_Role> SaveWorkflowRole(ICollection<Workflow_Role> entityList, DbContext dbContext)
        {
            ICollection<Workflow_Role> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Workflow_Role>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<Workflow_Module_Role> SaveWorkflowModuleRole(ICollection<Workflow_Module_Role> entityList, DbContext dbContext)
        {
            ICollection<Workflow_Module_Role> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Workflow_Module_Role>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Email_Config_Detail_Alert> SaveEmailConfigDetailAlert(ICollection<Email_Config_Detail_Alert> entityList, DbContext dbContext)
        {
            ICollection<Email_Config_Detail_Alert> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Email_Config_Detail_Alert>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<Email_Config_Detail_User> SaveEmailConfigDetailUser(ICollection<Email_Config_Detail_User> entityList, DbContext dbContext)
        {
            ICollection<Email_Config_Detail_User> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<Email_Config_Detail_User>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<ProjectMilestoneDetail> SaveProjectMilestoneDetail(ICollection<ProjectMilestoneDetail> entityList, DbContext dbContext)
        {
            ICollection<ProjectMilestoneDetail> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<ProjectMilestoneDetail>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<ProjectMilestoneTitle> SaveProjectMilestoneTitle(ICollection<ProjectMilestoneTitle> entityList, DbContext dbContext)
        {
            ICollection<ProjectMilestoneTitle> updatedList = entityList;

            updatedList = new Save_Entitiy_Lists_Generic<ProjectMilestoneTitle>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }

        public ICollection<AL_Vendor_Rule> SaveVendorRule(ICollection<AL_Vendor_Rule> entityList, DbContext dbContext)
        {
            ICollection<AL_Vendor_Rule> updatedList = entityList;
            updatedList = new Save_Entitiy_Lists_Generic<AL_Vendor_Rule>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<AL_Vendor_Rule_Criteria> SaveVendorRuleCriteria(ICollection<AL_Vendor_Rule_Criteria> entityList, DbContext dbContext)
        {
            ICollection<AL_Vendor_Rule_Criteria> updatedList = entityList;
            updatedList = new Save_Entitiy_Lists_Generic<AL_Vendor_Rule_Criteria>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<AL_Vendor_OEM> SaveVendorOEM(ICollection<AL_Vendor_OEM> entityList, DbContext dbContext)
        {
            ICollection<AL_Vendor_OEM> updatedList = entityList;
            updatedList = new Save_Entitiy_Lists_Generic<AL_Vendor_OEM>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
        public ICollection<AL_Vendor_TnC> SaveVendorTnC(ICollection<AL_Vendor_TnC> entityList, DbContext dbContext)
        {
            ICollection<AL_Vendor_TnC> updatedList = entityList;
            updatedList = new Save_Entitiy_Lists_Generic<AL_Vendor_TnC>().SetListFlagsCUD(updatedList, dbContext);
            return updatedList;
        }
    }

    public class Music_Album_Talent_Repository : RightsU_Repository<Music_Album_Talent>
    {
        public Music_Album_Talent_Repository(string conStr) : base(conStr) { }
    }

    public class Error_Code_Master_Repository : RightsU_Repository<Error_Code_Master>
    {
        public Error_Code_Master_Repository(string conStr) : base(conStr) { }
    }

    public class Deal_Workflow_Status_Repository : RightsU_Repository<Deal_Workflow_Status>
    {
        public Deal_Workflow_Status_Repository(string conStr) : base(conStr) { }
    }
    public class DM_Master_Import_Repository : RightsU_Repository<DM_Master_Import>
    {
        public DM_Master_Import_Repository(string conStr) : base(conStr) { }

        public override void Save(DM_Master_Import objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(DM_Master_Import objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class DM_Title_Resolve_Conflict_Repository : RightsU_Repository<DM_Title_Resolve_Conflict>
    {
        public DM_Title_Resolve_Conflict_Repository(string conStr) : base(conStr) { }
    }
    public class DM_Master_Log_Repository : RightsU_Repository<DM_Master_Log>
    {
        public DM_Master_Log_Repository(string conStr) : base(conStr) { }
    }
    public class DM_Music_Title_Repository : RightsU_Repository<DM_Music_Title>
    {
        public DM_Music_Title_Repository(string conStr) : base(conStr) { }
    }

    public class Workflow_Repository : RightsU_Repository<Workflow>
    {
        public Workflow_Repository(string conStr) : base(conStr) { }

        public override void Save(Workflow objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();

            if (objToSave.Workflow_Role != null) objToSave.Workflow_Role = objSaveEntities.SaveWorkflowRole(objToSave.Workflow_Role, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Workflow objToSave)
        {
            base.Delete(objToSave);
        }
    }

    public class Workflow_Role_Repository : RightsU_Repository<Workflow_Role>
    {
        public Workflow_Role_Repository(string conStr) : base(conStr) { }
    }

    public class BMS_Log_Repository : RightsU_Repository<BMS_Log>
    {
        public BMS_Log_Repository(string conStr) : base(conStr) { }
    }

    public class BMS_All_Masters_Repository : RightsU_Repository<BMS_All_Masters>
    {
        public BMS_All_Masters_Repository(string conStr) : base(conStr) { }
    }

    public class Workflow_Module_Repository : RightsU_Repository<Workflow_Module>
    {
        public Workflow_Module_Repository(string conStr) : base(conStr) { }

        public override void Save(Workflow_Module objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();

            if (objToSave.Workflow_Module_Role != null) objToSave.Workflow_Module_Role = objSaveEntities.SaveWorkflowModuleRole(objToSave.Workflow_Module_Role, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Workflow_Module objToSave)
        {
            base.Delete(objToSave);
        }
    }

    public class Workflow_Module_Role_Repository : RightsU_Repository<Workflow_Module_Role>
    {
        public Workflow_Module_Role_Repository(string conStr) : base(conStr) { }
    }
    public class DM_Title_Repository : RightsU_Repository<DM_Title>
    {
        public DM_Title_Repository(string conStr) : base(conStr) { }
    }

    public class Upload_Files_Repository : RightsU_Repository<Upload_Files>
    {
        public Upload_Files_Repository(string conStr) : base(conStr) { }

        public override void Save(Upload_Files objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();

            //  if (objToSave.Upload_Files_Role != null) objToSave.Upload_Files_Role = objSaveEntities.SaveUpload_FilesRole(objToSave.Upload_Files_Role, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Upload_Files objToSave)
        {
            base.Delete(objToSave);
        }
    }
    public class Program_Repository : RightsU_Repository<Program>
    {
        public Program_Repository(string conStr) : base(conStr) { }

        public override void Save(Program objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Program objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Channel_Territory_Repository : RightsU_Repository<Channel_Territory>
    {
        public Channel_Territory_Repository(string conStr) : base(conStr) { }


        public override void Save(Channel_Territory objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Channel_Territory objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Version_Repository : RightsU_Repository<RightsU_Entities.Version>
    {
        public Version_Repository(string conStr) : base(conStr) { }
    }

    public class Acq_Deal_Cost_Costtype_Episode_Repository : RightsU_Repository<Acq_Deal_Cost_Costtype_Episode>
    {
        public Acq_Deal_Cost_Costtype_Episode_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Cost_Costtype_Episode objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Acq_Deal_Cost_Costtype_Episode objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Acq_Deal_Cost_Title_Repository : RightsU_Repository<Acq_Deal_Cost_Title>
    {
        public Acq_Deal_Cost_Title_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Cost_Title objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Acq_Deal_Cost_Title objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Acq_Deal_Cost_Costtype_Repository : RightsU_Repository<Acq_Deal_Cost_Costtype>
    {
        public Acq_Deal_Cost_Costtype_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Deal_Cost_Costtype objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Acq_Deal_Cost_Costtype objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Syn_Deal_Revenue_Costtype_Repository : RightsU_Repository<Syn_Deal_Revenue_Costtype>
    {
        public Syn_Deal_Revenue_Costtype_Repository(string conStr) : base(conStr) { }

        public override void Save(Syn_Deal_Revenue_Costtype objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Syn_Deal_Revenue_Costtype objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Report_Territory_Repository : RightsU_Repository<Report_Territory>
    {
        public Report_Territory_Repository(string conStr) : base(conStr) { }
    }
    public class Report_Territory_Country_Repository : RightsU_Repository<Report_Territory_Country>
    {
        public Report_Territory_Country_Repository(string conStr) : base(conStr) { }
    }

    public class Email_Config_Repository : RightsU_Repository<Email_Config>
    {
        public Email_Config_Repository(string conStr) : base(conStr) { }
    }
    public class Email_Config_Detail_Repository : RightsU_Repository<Email_Config_Detail>
    {
        public Email_Config_Detail_Repository(string conStr) : base(conStr) { }
        public override void Save(Email_Config_Detail objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();

            if (objToSave.Email_Config_Detail_User != null) objToSave.Email_Config_Detail_User = objSaveEntities.SaveEmailConfigDetailUser(objToSave.Email_Config_Detail_User, base.DataContext);
            if (objToSave.Email_Config_Detail_Alert != null) objToSave.Email_Config_Detail_Alert = objSaveEntities.SaveEmailConfigDetailAlert(objToSave.Email_Config_Detail_Alert, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Email_Config_Detail objToSave)
        {
            base.Delete(objToSave);
        }
    }
    public class Email_Config_Detail_Alert_Repository : RightsU_Repository<Email_Config_Detail_Alert>
    {
        public Email_Config_Detail_Alert_Repository(string conStr) : base(conStr) { }
        public override void Save(Email_Config_Detail_Alert objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Email_Config_Detail_Alert objToSave)
        {
            base.Delete(objToSave);
        }
    }
    public class Email_Config_Detail_User_Repository : RightsU_Repository<Email_Config_Detail_User>
    {
        public Email_Config_Detail_User_Repository(string conStr) : base(conStr) { }
        public override void Save(Email_Config_Detail_User objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Email_Config_Detail_User objToSave)
        {
            base.Delete(objToSave);
        }
    }

    public class Channel_Category_Repository : RightsU_Repository<Channel_Category>
    {
        public Channel_Category_Repository(string conStr) : base(conStr) { }
    }

    public class Title_Alternate_Repository : RightsU_Repository<Title_Alternate>
    {
        public Title_Alternate_Repository(string conStr) : base(conStr) { }
        public override void Save(Title_Alternate objTitleAlternate)
        {
            Save_Title_Alternate_Entities_Generic objSaveEntities = new Save_Title_Alternate_Entities_Generic();

            if (objTitleAlternate.Title_Alternate_Talent != null) objTitleAlternate.Title_Alternate_Talent = objSaveEntities.SaveTalent(objTitleAlternate.Title_Alternate_Talent, base.DataContext);
            if (objTitleAlternate.Title_Alternate_Genres != null) objTitleAlternate.Title_Alternate_Genres = objSaveEntities.SaveGenre(objTitleAlternate.Title_Alternate_Genres, base.DataContext);
            if (objTitleAlternate.Title_Alternate_Country != null) objTitleAlternate.Title_Alternate_Country = objSaveEntities.SaveCountry(objTitleAlternate.Title_Alternate_Country, base.DataContext);

            if (objTitleAlternate.EntityState == State.Added)
            {
                base.Save(objTitleAlternate);
            }
            else if (objTitleAlternate.EntityState == State.Modified)
            {
                base.Update(objTitleAlternate);
            }
            else if (objTitleAlternate.EntityState == State.Deleted)
            {
                base.Delete(objTitleAlternate);
            }
        }
        public override void Delete(Title_Alternate objTitleAlternate)
        {
            base.Delete(objTitleAlternate);
        }
    }

    public class Save_Title_Alternate_Entities_Generic
    {
        public ICollection<Title_Alternate_Talent> SaveTalent(ICollection<Title_Alternate_Talent> entityTitles, DbContext dbContext)
        {
            ICollection<Title_Alternate_Talent> UpdatedTalents = entityTitles;

            UpdatedTalents = new Save_Entitiy_Lists_Generic<Title_Alternate_Talent>().SetListFlagsCUD(UpdatedTalents, dbContext);

            return UpdatedTalents;
        }

        public ICollection<Title_Alternate_Genres> SaveGenre(ICollection<Title_Alternate_Genres> entityTitles, DbContext dbContext)
        {
            ICollection<Title_Alternate_Genres> UpdatedGenre = entityTitles;

            UpdatedGenre = new Save_Entitiy_Lists_Generic<Title_Alternate_Genres>().SetListFlagsCUD(UpdatedGenre, dbContext);

            return UpdatedGenre;
        }

        public ICollection<Title_Alternate_Country> SaveCountry(ICollection<Title_Alternate_Country> entityTitles, DbContext dbContext)
        {
            ICollection<Title_Alternate_Country> UpdatedGenre = entityTitles;

            UpdatedGenre = new Save_Entitiy_Lists_Generic<Title_Alternate_Country>().SetListFlagsCUD(UpdatedGenre, dbContext);

            return UpdatedGenre;
        }
    }
    public class Alternate_Config_Repository : RightsU_Repository<Alternate_Config>
    {
        public Alternate_Config_Repository(string conStr) : base(conStr) { }
    }
    public class Title_Alternate_Talent_Repository : RightsU_Repository<Title_Alternate_Talent>
    {
        public Title_Alternate_Talent_Repository(string conStr) : base(conStr) { }
    }
    public class Title_Alternate_Genres_Repository : RightsU_Repository<Title_Alternate_Genres>
    {
        public Title_Alternate_Genres_Repository(string conStr) : base(conStr) { }
    }
    public class Title_Alternate_Country_Repository : RightsU_Repository<Title_Alternate_Country>
    {
        public Title_Alternate_Country_Repository(string conStr) : base(conStr) { }
    }

    public class Title_Alternate_Content_Repository : RightsU_Repository<Title_Alternate_Content>
    {
        public Title_Alternate_Content_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Alternate_Content objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Title_Alternate_Content objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Report_Format_Repository : RightsU_Repository<Report_Format>
    {
        public Report_Format_Repository(string conStr) : base(conStr) { }
    }

    public class Language_Group_Details_Repository : RightsU_Repository<Language_Group_Details>
    {
        public Language_Group_Details_Repository(string conStr) : base(conStr) { }

        public override void Save(Language_Group_Details obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }

        public override void Delete(Language_Group_Details obj)
        {
            base.Delete(obj);
        }
    }
    public class System_Language_Message_Repository : RightsU_Repository<System_Language_Message>
    {
        public System_Language_Message_Repository(string conStr) : base(conStr) { }

        public override void Save(System_Language_Message objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(System_Language_Message objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class System_Language_Repository : RightsU_Repository<System_Language>
    {
        public System_Language_Repository(string conStr) : base(conStr) { }

        public override void Save(System_Language objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
    }
    public class Email_Notification_Log_Repository : RightsU_Repository<Email_Notification_Log>
    {
        public Email_Notification_Log_Repository(string conStr) : base(conStr) { }
        public override void Save(Email_Notification_Log objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Email_Notification_Log objToSave)
        {
            base.Delete(objToSave);
        }
    }
    public class System_Message_Repository : RightsU_Repository<System_Message>
    {
        public System_Message_Repository(string conStr) : base(conStr) { }
        public override void Save(System_Message objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }

    }

    public class Provisional_Deal_Run_Repository : RightsU_Repository<Provisional_Deal_Run>
    {
        public Provisional_Deal_Run_Repository(string conStr) : base(conStr) { }

        public override void Save(Provisional_Deal_Run objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Provisional_Deal_Run objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Provisional_Deal_Run_Channel_Repository : RightsU_Repository<Provisional_Deal_Run_Channel>
    {
        public Provisional_Deal_Run_Channel_Repository(string conStr) : base(conStr) { }

        public override void Save(Provisional_Deal_Run_Channel objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Provisional_Deal_Run_Channel objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Channel_Category_Details_Repository : RightsU_Repository<Channel_Category_Details>
    {
        public Channel_Category_Details_Repository(string conStr) : base(conStr) { }
    }
    public class DM_Content_Music_Repository : RightsU_Repository<DM_Content_Music>
    {
        public DM_Content_Music_Repository(string conStr) : base(conStr) { }
        public override void Save(DM_Content_Music objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
    }
    public class MQ_Log_Repository : RightsU_Repository<MQ_Log>
    {
        public MQ_Log_Repository(string conStr) : base(conStr) { }
    }
    public class BMS_Asset_Repository : RightsU_Repository<BMS_Asset>
    {
        public BMS_Asset_Repository(string conStr) : base(conStr) { }
        public override void Save(BMS_Asset objBMS_Asset)
        {
            if (objBMS_Asset.EntityState == State.Added)
            {
                base.Save(objBMS_Asset);
            }
            else if (objBMS_Asset.EntityState == State.Modified)
            {
                base.Update(objBMS_Asset);
            }
            else if (objBMS_Asset.EntityState == State.Deleted)
            {
                base.Delete(objBMS_Asset);
            }
        }
    }
    public class BMS_Deal_Repository : RightsU_Repository<BMS_Deal>
    {
        public BMS_Deal_Repository(string conStr) : base(conStr) { }
        public override void Save(BMS_Deal objBMS_Deal)
        {
            if (objBMS_Deal.EntityState == State.Added)
            {
                base.Save(objBMS_Deal);
            }
            else if (objBMS_Deal.EntityState == State.Modified)
            {
                base.Update(objBMS_Deal);
            }
            else if (objBMS_Deal.EntityState == State.Deleted)
            {
                base.Delete(objBMS_Deal);
            }
        }
    }
    public class BMS_Deal_Content_Repository : RightsU_Repository<BMS_Deal_Content>
    {
        public BMS_Deal_Content_Repository(string conStr) : base(conStr) { }
        public override void Save(BMS_Deal_Content objBMS_Deal_Content)
        {
            if (objBMS_Deal_Content.EntityState == State.Added)
            {
                base.Save(objBMS_Deal_Content);
            }
            else if (objBMS_Deal_Content.EntityState == State.Modified)
            {
                base.Update(objBMS_Deal_Content);
            }
            else if (objBMS_Deal_Content.EntityState == State.Deleted)
            {
                base.Delete(objBMS_Deal_Content);
            }
        }
    }
    public class BMS_Deal_Content_Rights_Repository : RightsU_Repository<BMS_Deal_Content_Rights>
    {
        public BMS_Deal_Content_Rights_Repository(string conStr) : base(conStr) { }
        public override void Save(BMS_Deal_Content_Rights objBMS_Deal_Content_Rights)
        {
            if (objBMS_Deal_Content_Rights.EntityState == State.Added)
            {
                base.Save(objBMS_Deal_Content_Rights);
            }
            else if (objBMS_Deal_Content_Rights.EntityState == State.Modified)
            {
                base.Update(objBMS_Deal_Content_Rights);
            }
            else if (objBMS_Deal_Content_Rights.EntityState == State.Deleted)
            {
                base.Delete(objBMS_Deal_Content_Rights);
            }
        }
    }

    public class Milestone_Nature_Repository : RightsU_Repository<Milestone_Nature>
    {
        public Milestone_Nature_Repository(string conStr) : base(conStr) { }

        public override void Save(Milestone_Nature objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Milestone_Nature objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Title_Milestone_Repository : RightsU_Repository<Title_Milestone>
    {
        public Title_Milestone_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Milestone objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Title_Milestone objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class TAT_Repository : RightsU_Repository<TAT>
    {
        public TAT_Repository(string conStr) : base(conStr) { }

        public override void Save(TAT objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(TAT objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class TATSLA_Repository : RightsU_Repository<TATSLA>
    {
        public TATSLA_Repository(string conStr) : base(conStr) { }

        public override void Save(TATSLA objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(TATSLA objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class TATSLAMatrix_Repository : RightsU_Repository<TATSLAMatrix>
    {
        public TATSLAMatrix_Repository(string conStr) : base(conStr) { }

        public override void Save(TATSLAMatrix objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(TATSLAMatrix objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class TATSLAMatrixDetail_Repository : RightsU_Repository<TATSLAMatrixDetail>
    {
        public TATSLAMatrixDetail_Repository(string conStr) : base(conStr) { }

        public override void Save(TATSLAMatrixDetail objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(TATSLAMatrixDetail objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class TATSLAStatus_Repository : RightsU_Repository<TATSLAStatus>
    {
        public TATSLAStatus_Repository(string conStr) : base(conStr) { }
    }
    public class TATStatusLog_Repository : RightsU_Repository<TATStatusLog>
    {
        public TATStatusLog_Repository(string conStr) : base(conStr) { }

        public override void Save(TATStatusLog objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(TATStatusLog objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class ProjectMilestone_Repository : RightsU_Repository<ProjectMilestone>
    {
        public ProjectMilestone_Repository(string conStr) : base(conStr) { }

        public override void Save(ProjectMilestone objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.ProjectMilestoneDetails != null) objToSave.ProjectMilestoneDetails = objSaveEntities.SaveProjectMilestoneDetail(objToSave.ProjectMilestoneDetails, base.DataContext);

            if (objToSave.ProjectMilestoneTitles != null) objToSave.ProjectMilestoneTitles = objSaveEntities.SaveProjectMilestoneTitle(objToSave.ProjectMilestoneTitles, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(ProjectMilestone objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class ProjectMilestoneDetail_Repository : RightsU_Repository<ProjectMilestoneDetail>
    {
        public ProjectMilestoneDetail_Repository(string conStr) : base(conStr) { }

        public override void Save(ProjectMilestoneDetail objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(ProjectMilestoneDetail objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class ProjectMilestoneTitle_Repository : RightsU_Repository<ProjectMilestoneTitle>
    {
        public ProjectMilestoneTitle_Repository(string conStr) : base(conStr) { }

        public override void Save(ProjectMilestoneTitle objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(ProjectMilestoneTitle objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Party_Category_Repository : RightsU_Repository<Party_Category>
    {
        public Party_Category_Repository(string conStr) : base(conStr) { }

        public override void Save(Party_Category objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Party_Category objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Users_Configuration_Repository : RightsU_Repository<Users_Configuration>
    {
        public Users_Configuration_Repository(string conStr) : base(conStr) { }
        public override void Save(Users_Configuration obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }
        public override void Delete(Users_Configuration obj)
        {
            base.Delete(obj);
        }
    }
    public class Users_Exclusion_Rights_Repository : RightsU_Repository<Users_Exclusion_Rights>
    {
        public Users_Exclusion_Rights_Repository(string conStr) : base(conStr) { }
        public override void Save(Users_Exclusion_Rights obj)
        {
            if (obj.EntityState == State.Added)
            {
                base.Save(obj);
            }
            else if (obj.EntityState == State.Modified)
            {
                base.Update(obj);
            }
            else if (obj.EntityState == State.Deleted)
            {
                base.Delete(obj);
            }
        }
        public override void Delete(Users_Exclusion_Rights obj)
        {
            base.Delete(obj);
        }
    }

    public class Party_Group_Repository : RightsU_Repository<Party_Group>
    {
        public Party_Group_Repository(string conStr) : base(conStr) { }

        public override void Save(Party_Group objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Party_Group objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Acq_Adv_Ancillary_Report_Repository : RightsU_Repository<Acq_Adv_Ancillary_Report>
    {
        public Acq_Adv_Ancillary_Report_Repository(string conStr) : base(conStr) { }

        public override void Save(Acq_Adv_Ancillary_Report objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Acq_Adv_Ancillary_Report objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    public class Deal_Segment_Repository : RightsU_Repository<Deal_Segment>
    {
        public Deal_Segment_Repository(string conStr) : base(conStr) { }
    }

    public class Platform_Broadcast_Repository : RightsU_Repository<Platform_Broadcast>
    {
        public Platform_Broadcast_Repository(string conStr) : base(conStr) { }
    }

    public class Revenue_Vertical_Repository : RightsU_Repository<Revenue_Vertical>
    {
        public Revenue_Vertical_Repository(string conStr) : base(conStr) { }
    }
    public class DM_Title_Import_Utility_Repository : RightsU_Repository<DM_Title_Import_Utility>
    {
        public DM_Title_Import_Utility_Repository(string conStr) : base(conStr) { }
    }
    public class DM_Title_Import_Utility_Data_Repository : RightsU_Repository<DM_Title_Import_Utility_Data>
    {
        public DM_Title_Import_Utility_Data_Repository(string conStr) : base(conStr) { }
    }

    public class Title_Objection_Status_Repository : RightsU_Repository<Title_Objection_Status>
    {
        public Title_Objection_Status_Repository(string conStr) : base(conStr) { }
    }

    public class Title_Objection_Platform_Repository : RightsU_Repository<Title_Objection_Platform>
    {
        public Title_Objection_Platform_Repository(string conStr) : base(conStr) { }

    }

    public class Title_Objection_Territory_Repository : RightsU_Repository<Title_Objection_Territory>
    {
        public Title_Objection_Territory_Repository(string conStr) : base(conStr) { }

    }

    public class Title_Objection_Rights_Period_Repository : RightsU_Repository<Title_Objection_Rights_Period>
    {
        public Title_Objection_Rights_Period_Repository(string conStr) : base(conStr) { }

    }

    public class Title_Objection_Type_Repository : RightsU_Repository<Title_Objection_Type>
    {
        public Title_Objection_Type_Repository(string conStr) : base(conStr) { }
    }

    public class Title_Objection_Repository : RightsU_Repository<Title_Objection>
    {
        public Title_Objection_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Objection objToSave)
        {
            Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
            if (objToSave.Title_Objection_Platform != null) objToSave.Title_Objection_Platform = objSaveEntities.SaveTitle_Objection_Platform(objToSave.Title_Objection_Platform, base.DataContext);
            if (objToSave.Title_Objection_Territory != null) objToSave.Title_Objection_Territory = objSaveEntities.SaveTitle_Objection_Territory(objToSave.Title_Objection_Territory, base.DataContext);
            if (objToSave.Title_Objection_Rights_Period != null) objToSave.Title_Objection_Rights_Period = objSaveEntities.SaveTitle_Objection_Rights_Period(objToSave.Title_Objection_Rights_Period, base.DataContext);

            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
    }

    public class Attrib_Group_Repository : RightsU_Repository<Attrib_Group>
    {
        public Attrib_Group_Repository(string conStr) : base(conStr) { }
        public override void Save(Attrib_Group objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
    }

    public class Supplementary_Repository : RightsU_Repository<Supplementary>
    {
        public Supplementary_Repository(string constr) : base(constr) { }
    }

    public class Supplementary_Data_Repository : RightsU_Repository<Supplementary_Data>
    {
        public Supplementary_Data_Repository(string constr) : base(constr) { }
    }

    public class Supplementary_Tab_Repository : RightsU_Repository<Supplementary_Tab>
    {
        public Supplementary_Tab_Repository(string constr) : base(constr) { }
    }

    public class Supplementary_Config_Repository : RightsU_Repository<Supplementary_Config>
    {
        public Supplementary_Config_Repository(string constr) : base(constr) { }
    }

    #region Added for File uplaod in demo setup 
    public class ImgPathData_Repository : RightsU_Repository<ImgPathData>
    {
        public ImgPathData_Repository(string conStr) : base(conStr) { }

        public override void Save(ImgPathData objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(ImgPathData objToDelete)
        {
            base.Delete(objToDelete);
        }
    }
    #endregion
    public class Digital_Repository : RightsU_Repository<Digital>
    {
        public Digital_Repository(string constr) : base(constr) { }
    }

    public class Digital_Data_Repository : RightsU_Repository<Digital_Data>
    {
        public Digital_Data_Repository(string constr) : base(constr) { }
    }

    public class Digital_Tab_Repository : RightsU_Repository<Digital_Tab>
    {
        public Digital_Tab_Repository(string constr) : base(constr) { }
    }

    public class Digital_Config_Repository : RightsU_Repository<Digital_Config>
    {
        public Digital_Config_Repository(string constr) : base(constr) { }
    }

    public class Extended_Group_Config_Repository : RightsU_Repository<Extended_Group_Config>
    {
        public Extended_Group_Config_Repository(string conStr) : base(conStr) { }

        public override void Save(Extended_Group_Config objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Extended_Group_Config objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Extended_Group_Repository : RightsU_Repository<Extended_Group>
    {
        public Extended_Group_Repository(string conStr) : base(conStr) { }

        public override void Save(Extended_Group objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Extended_Group objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    #region------------Aeroplay---------------

    public class AL_Vendor_Details_Repository : RightsU_Repository<AL_Vendor_Details>
    {
        public AL_Vendor_Details_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Vendor_Details objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Vendor_Details objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Vendor_TnC_Repository : RightsU_Repository<AL_Vendor_TnC>
    {
        public AL_Vendor_TnC_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Vendor_TnC objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Vendor_TnC objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Vendor_Rule_Criteria_Repository : RightsU_Repository<AL_Vendor_Rule_Criteria>
    {
        public AL_Vendor_Rule_Criteria_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Vendor_Rule_Criteria objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Vendor_Rule_Criteria objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Vendor_OEM_Repository : RightsU_Repository<AL_Vendor_OEM>
    {
        public AL_Vendor_OEM_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Vendor_OEM objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Vendor_OEM objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Vendor_Rule_Repository : RightsU_Repository<AL_Vendor_Rule>
    {
        public AL_Vendor_Rule_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Vendor_Rule objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Vendor_Rule objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_OEM_Repository : RightsU_Repository<AL_OEM>
    {
        public AL_OEM_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_OEM objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_OEM objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Banner_Repository : RightsU_Repository<Banner>
    {
        public Banner_Repository(string conStr) : base(conStr) { }

        public override void Save(Banner objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Banner objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Title_Episode_Details_TC_Repository : RightsU_Repository<Title_Episode_Details_TC>
    {
        public Title_Episode_Details_TC_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Episode_Details_TC objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Title_Episode_Details_TC objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class Title_Episode_Details_Repository : RightsU_Repository<Title_Episode_Details>
    {
        public Title_Episode_Details_Repository(string conStr) : base(conStr) { }

        public override void Save(Title_Episode_Details objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(Title_Episode_Details objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Lab_Repository : RightsU_Repository<AL_Lab>
    {
        public AL_Lab_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Lab objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Lab objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Booking_Sheet_Repository : RightsU_Repository<AL_Booking_Sheet>
    {
        public AL_Booking_Sheet_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Booking_Sheet objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Booking_Sheet objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Booking_Sheet_Details_Repository : RightsU_Repository<AL_Booking_Sheet_Details>
    {
        public AL_Booking_Sheet_Details_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Booking_Sheet_Details objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Booking_Sheet_Details objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Recommendation_Repository : RightsU_Repository<AL_Recommendation>
    {
        public AL_Recommendation_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Recommendation objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Recommendation objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    public class AL_Recommendation_Content_Repository : RightsU_Repository<AL_Recommendation_Content>
    {
        public AL_Recommendation_Content_Repository(string conStr) : base(conStr) { }

        public override void Save(AL_Recommendation_Content objToSave)
        {
            if (objToSave.EntityState == State.Added)
            {
                base.Save(objToSave);
            }
            else if (objToSave.EntityState == State.Modified)
            {
                base.Update(objToSave);
            }
            else if (objToSave.EntityState == State.Deleted)
            {
                base.Delete(objToSave);
            }
        }
        public override void Delete(AL_Recommendation_Content objToDelete)
        {
            base.Delete(objToDelete);
        }
    }

    #endregion
}
