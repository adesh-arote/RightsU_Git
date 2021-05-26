using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
using RightsU_Dapper.Entity.Master_Entities;
using RightsU_Dapper.Entity.StoredProcedure_Entities;
using RightsU_Dapper.Entity.System_Setting_Entities;
using System;
using System.Collections.Generic;
using System.Data;

namespace RightsU_Dapper.DAL.Repository
{
    public class Music_Deal_Repository : MainRepository<Music_Deal_Dapper>
    {
        public Music_Deal_Dapper Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Deal_Code = Id };
            return base.GetById<Music_Deal_Dapper>(obj, RelationList);
        }
        public void Add(Music_Deal_Dapper entity)
        {
            Music_Deal_Dapper oldObj = Get(entity.Music_Deal_Code);
            base.UpdateEntity(oldObj, entity);
            //base.AddEntity(entity);
        }
        public void Update(Music_Deal_Dapper entity)
        {
            Music_Deal_Dapper oldObj = Get(entity.Music_Deal_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Deal_Dapper entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Music_Deal_Dapper> GetAll()
        {
            return base.GetAll<Music_Deal_Dapper>();
        }
        public IEnumerable<Music_Deal_Dapper> SearchFor(object param)
        {
            return base.SearchForEntity<Music_Deal_Dapper>(param);
        }
        public IEnumerable<USP_List_Music_Deal_Result> USP_List_Music_Deal(string searchText, string agreement_No, Nullable<System.DateTime> startDate, Nullable<System.DateTime> endDate, string deal_Type_Code, string status_Code, Nullable<int> business_Unit_Code, Nullable<int> deal_Tag_Code, string workflow_Status, string vendor_Codes, string show_Type_Code, string title_Code, string music_Label_Codes, string isAdvance_Search, Nullable<int> user_Code, int pageNo, Nullable<int> pageSize, out int recordCount)
        {
            var param = new DynamicParameters();

            param.Add("@SearchText", searchText);
            param.Add("@Agreement_No", agreement_No);
            param.Add("@StartDate", startDate);
            param.Add("@EndDate", endDate);
            param.Add("@Deal_Type_Code", deal_Type_Code);
            param.Add("@Status_Code", status_Code);
            param.Add("@Business_Unit_Code", business_Unit_Code);
            param.Add("@Deal_Tag_Code", deal_Tag_Code);
            param.Add("@Workflow_Status", workflow_Status);
            param.Add("@Vendor_Codes", vendor_Codes);
            param.Add("@Music_Label_Codes", music_Label_Codes);
            param.Add("@IsAdvance_Search", isAdvance_Search);
            param.Add("@Show_Type_Code", show_Type_Code);
            param.Add("@Title_Code", title_Code);
            param.Add("@User_Code", user_Code);
            param.Add("@PageNo", pageNo);
            param.Add("@PageSize", pageSize);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);

            IEnumerable<USP_List_Music_Deal_Result> lstUSP_List_Music_Deal_Result = base.ExecuteSQLProcedure<USP_List_Music_Deal_Result>("USP_List_Music_Deal", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_List_Music_Deal_Result;
        }
        public IEnumerable<USP_Music_Deal_Link_Show_Result> USP_Music_Deal_Link_Show(string channel_Code, string title_Name, string mode, Nullable<int> music_Deal_Code, string selectedTitleCodes)
        {
            var param = new DynamicParameters();

            param.Add("@Channel_Code", channel_Code);
            param.Add("@Title_Name", title_Name);
            param.Add("@Mode", mode);
            param.Add("@Music_Deal_Code", music_Deal_Code);
            param.Add("@SelectedTitleCodes", selectedTitleCodes);

            return base.ExecuteSQLProcedure<USP_Music_Deal_Link_Show_Result>("USP_Music_Deal_Link_Show", param);

        }
        public IEnumerable<USP_Music_Deal_Schedule_Validation_Result> USP_Music_Deal_Schedule_Validation(int? Music_Deal_Code, string Channel_Codes, string Start_Date, string End_Date, string Title_Codes, string LinkshowType)
        {
            var param = new DynamicParameters();

            param.Add("@Music_Deal_Code", Music_Deal_Code);
            param.Add("@Channel_Codes", Channel_Codes);
            param.Add("@Start_Date", Start_Date);
            param.Add("@End_Date", End_Date);
            param.Add("@LinkedShowType", LinkshowType);
            param.Add("@LinkedTitleCode", Title_Codes);

            return base.ExecuteSQLProcedure<USP_Music_Deal_Schedule_Validation_Result>("USP_Music_Deal_Schedule_Validation", param);
        }
        public string USP_RollBack_Music_Deal(Nullable<int> music_Deal_Code, Nullable<int> user_Code, out string errorMessage)
        {
            var param = new DynamicParameters();

            param.Add("@Music_Deal_Code", music_Deal_Code);
            param.Add("@User_Code", user_Code);
            param.Add("@ErrorMessage", dbType: DbType.String, direction: ParameterDirection.Output);

            string Result = base.ExecuteScalar("USP_RollBack_Music_Deal", param);
            errorMessage = param.Get<string>("@ErrorMessage");
            return Result;

        }
        public IEnumerable<Deal_Creation> USP_Insert_Music_Deal(Music_Deal_Dapper entity)
        {
            var param = new DynamicParameters();

            param.Add("@Version", entity.Version);
            param.Add("@Agreement_Date", entity.Agreement_Date);
            param.Add("@Description", entity.Description);
            param.Add("@Deal_Tag_Code", entity.Deal_Tag_Code);
            param.Add("@Reference_No", entity.Reference_No);
            param.Add("@Entity_Code", entity.Entity_Code);
            param.Add("@Primary_Vendor_Code", entity.Primary_Vendor_Code);
            param.Add("@Music_Label_Code", entity.Music_Label_Code);
            param.Add("@Title_Type", entity.Title_Type);
            param.Add("@Duration_Restriction", entity.Duration_Restriction);
            param.Add("@Rights_Start_Date", entity.Rights_Start_Date);
            param.Add("@Rights_End_Date", entity.Rights_End_Date);
            param.Add("@Term", entity.Term);
            param.Add("@Run_Type", entity.Run_Type);
            param.Add("@No_Of_Songs", entity.No_Of_Songs);
            param.Add("@Channel_Type", entity.Channel_Type);
            param.Add("@Right_Rule_Code", entity.Right_Rule_Code);
            param.Add("@Link_Show_Type", entity.Link_Show_Type);
            param.Add("@Business_Unit_Code", entity.Business_Unit_Code);
            param.Add("@Deal_Type_Code", entity.Deal_Type_Code);
            param.Add("@Deal_Workflow_Status", entity.Deal_Workflow_Status);
            param.Add("@Parent_Deal_Code", entity.Parent_Deal_Code);
            param.Add("@Work_Flow_Code", entity.Work_Flow_Code);
            param.Add("@Inserted_By", entity.Inserted_By);
            param.Add("@Last_Action_By", entity.Last_Action_By);
            param.Add("@Remarks", entity.Remarks);
            param.Add("@Agreement_Cost", entity.Agreement_Cost);
            param.Add("@Channel_Or_Category", entity.Channel_Or_Category);
            param.Add("@Channel_Category_Code", entity.Channel_Category_Code);
            param.Add("@Right_Rule_Type", entity.Right_Rule_Type);

            return base.ExecuteSQLProcedure<Deal_Creation>("USP_Insert_Music_Deal", param);
        }
    }

    public class Music_Deal_Platform_Repository : MainRepository<Music_Deal_Platform_Dapper>
    {
        public void DeleteAll(List<Music_Deal_Platform_Dapper> ListEntity)
        {
            base.DeleteAllEntity(ListEntity);
        }
    }
    public class Vendor_Repository : MainRepository<Vendor>
    {
        public Vendor Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Vendor_Code = Id };
            return base.GetById<Vendor>(obj, RelationList);
        }
        public void Add(Vendor entity)
        {
            Vendor oldObj = Get(entity.Vendor_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Vendor entity)
        {
            Vendor oldObj = Get(entity.Vendor_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Vendor entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Vendor> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Vendor>(additionalTypes);
        }
        public IEnumerable<Vendor> SearchFor(object param)
        {
            return base.SearchForEntity<Vendor>(param);
        }
    }
    public class Vendor_Country_Repository : MainRepository<Vendor_Country>
    {
        public Vendor_Country Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Vendor_Country_Code = Id };
            return base.GetById<Vendor_Country>(obj, RelationList);
        }
        public void Add(Vendor_Country entity)
        {
            Vendor_Country oldObj = Get(entity.Vendor_Country_Code);
            base.UpdateEntity(oldObj, entity);
            //base.AddEntity(entity);
        }
        public void Update(Vendor_Country entity)
        {
            Vendor_Country oldObj = Get(entity.Vendor_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Vendor_Country entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Vendor_Country> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Vendor_Country>(additionalTypes);
        }
        public IEnumerable<Vendor_Country> SearchFor(object param)
        {
            return base.SearchForEntity<Vendor_Country>(param);
        }
    }
    public class Party_Category_Repository : MainRepository<Party_Category>
    {
        public Party_Category Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Party_Category_Code = Id };
            return base.GetById<Party_Category>(obj, RelationList);
        }
        public IEnumerable<Party_Category> GetAll()
        {
            return base.GetAll<Party_Category>();
        }
    }
    public class Party_Group_Repository : MainRepository<Party_Group>
    {
        public Party_Group Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Party_Group_Code = Id };
            return base.GetById<Party_Group>(obj, RelationList);
        }
        public void Add(Party_Group entity)
        {
            Party_Group oldObj = Get(entity.Party_Group_Code);
            base.UpdateEntity(oldObj, entity);
            //base.AddEntity(entity);
        }
        public void Update(Party_Group entity)
        {
            Party_Group oldObj = Get(entity.Party_Group_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Party_Group entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Party_Group> GetAll()
        {
            return base.GetAll<Party_Group>();
        }
        public IEnumerable<Party_Group> SearchFor(object param)
        {
            return base.SearchForEntity<Party_Group>(param);
        }
    }
    public class Vendor_Role_Repository : MainRepository<Vendor_Role>
    {
        public Vendor_Role Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Vendor_Role_Code = Id };
            return base.GetById<Vendor_Role>(obj, RelationList);
        }
        public void Add(Vendor_Role entity)
        {
            Vendor_Role oldObj = Get(entity.Vendor_Role_Code);
            base.UpdateEntity(oldObj, entity);
            //base.AddEntity(entity);
        }
        public void Update(Vendor_Role entity)
        {
            Vendor_Role oldObj = Get(entity.Vendor_Role_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Vendor_Role entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Vendor_Role> GetAll()
        {
            return base.GetAll<Party_Group>();
        }
        public IEnumerable<Vendor_Role> SearchFor(object param)
        {
            return base.SearchForEntity<Vendor_Role>(param);
        }
    }
    public class Country_Repository : MainRepository<Country>
    {
        public Country Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Country_Code = Id };
            return base.GetById<Country>(obj, RelationList);
        }
        public void Add(Country entity)
        {
            Country oldObj = Get(entity.Country_Code);
            base.UpdateEntity(oldObj, entity);
            //base.AddEntity(entity);
        }
        public void Update(Country entity)
        {
            Country oldObj = Get(entity.Country_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Country entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Country> GetAll()
        {
            return base.GetAll<Country>();
        }
        public IEnumerable<Country> SearchFor(object param)
        {
            return base.SearchForEntity<Country>(param);
        }
    }
    public class Vendor_Contacts_Repository : MainRepository<Vendor_Contacts>
    {
        public Vendor_Contacts Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Vendor_Contacts_Code = Id };
            return base.GetById<Vendor_Contacts>(obj, RelationList);
        }
        public void Add(Vendor_Contacts entity)
        {
            Vendor_Contacts oldObj = Get(entity.Vendor_Contacts_Code);
            base.UpdateEntity(oldObj, entity);
            //base.AddEntity(entity);
        }
        public void Update(Vendor_Contacts entity)
        {
            Vendor_Contacts oldObj = Get(entity.Vendor_Contacts_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Vendor_Contacts entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Vendor_Contacts> GetAll()
        {
            return base.GetAll<Vendor_Contacts>();
        }
        public IEnumerable<Vendor_Contacts> SearchFor(object param)
        {
            return base.SearchForEntity<Vendor_Contacts>(param);
        }
    }
    public class USP_MODULE_RIGHTS_Repository : ProcRepository
    {
        public string USP_MODULE_RIGHTS(Nullable<int> module_Code, Nullable<int> security_Group_Code, Nullable<int> users_Code)
        {
            var param = new DynamicParameters();

            param.Add("@Module_Code", module_Code);
            param.Add("@Security_Group_Code", security_Group_Code);
            param.Add("@Users_Code", users_Code);

            string Result = base.ExecuteScalar("USP_MODULE_RIGHTS", param);
            return Result;
        }
    }
    public class Territory_Repository : MainRepository<Territory>
    {
        public Territory Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Territory_Code = Id };
            return base.GetById<Territory>(obj, RelationList);
        }
        public void Add(Territory entity)
        {
            Territory oldObj = Get(entity.Territory_Code);
            base.UpdateEntity(oldObj, entity);
            //base.AddEntity(entity);
        }
        public void Update(Territory entity)
        {
            Territory oldObj = Get(entity.Territory_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Territory entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Territory> GetAll()
        {
            return base.GetAll<Territory>();
        }
        public IEnumerable<Territory> SearchFor(object param)
        {
            return base.SearchForEntity<Territory>(param);
        }
    }
    public class Territory_Details_Repository : MainRepository<Territory_Details>
    {
        public Territory_Details Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Territory_Details_Code = Id };
            return base.GetById<Territory_Details>(obj, RelationList);
        }
        public void Add(Territory_Details entity)
        {
            Territory_Details oldObj = Get(entity.Territory_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Territory_Details entity)
        {
            Territory_Details oldObj = Get(entity.Territory_Details_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Territory_Details entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Territory_Details> GetAll()
        {
            return base.GetAll<Territory_Details>();
        }
        public IEnumerable<Territory_Details> SearchFor(object param)
        {
            return base.SearchForEntity<Territory_Details>(param);
        }
    }
    public class USP_List_Territory_Repository : ProcRepository
    {
        public IEnumerable<USP_List_Territory_Result> USP_List_Territory(Nullable<int> sysLanguageCode)
        {
            var param = new DynamicParameters();

            param.Add("@SysLanguageCode", sysLanguageCode);

            return base.ExecuteSQLProcedure<USP_List_Territory_Result>("USP_List_Territory", param);
        }
    }
    public class Language_Repository : MainRepository<Language>
    {
        public Language Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Language_Code = Id };
            return base.GetById<Language>(obj, RelationList);
        }
        public void Add(Language entity)
        {
            Language oldObj = Get(entity.Language_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Language entity)
        {
            Language oldObj = Get(entity.Language_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Language entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Language> GetAll()
        {
            return base.GetAll<Language>();
        }
        public IEnumerable<Language> SearchFor(object param)
        {
            return base.SearchForEntity<Language>(param);
        }
    }
    public class Addtional_Expense_Repository : MainRepository<Additional_Expense>
    {
        public Additional_Expense Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Additional_Expense_Code = Id };
            return base.GetById<Additional_Expense>(obj, RelationList);
        }
        public void Add(Additional_Expense entity)
        {
            Additional_Expense oldObj = Get(entity.Additional_Expense_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Additional_Expense entity)
        {
            Additional_Expense oldObj = Get(entity.Additional_Expense_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Additional_Expense entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Additional_Expense> GetAll()
        {
            return base.GetAll<Additional_Expense>();
        }
        public IEnumerable<Additional_Expense> SearchFor(object param)
        {
            return base.SearchForEntity<Additional_Expense>(param);
        }
    }
    public class Role_Repository : MainRepository<Role>
    {
        public Role Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Role_Code = Id };
            return base.GetById<Role>(obj, RelationList);
        }
        public void Add(Role entity)
        {
            Role oldObj = Get(entity.Role_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Role entity)
        {
            Role oldObj = Get(entity.Role_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Role entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Role> GetAll()
        {
            return base.GetAll<Role>();
        }
        public IEnumerable<Role> SearchFor(object param)
        {
            return base.SearchForEntity<Role>(param);
        }
    }
    public class Channel_Repository : MainRepository<Channel>
    {
        public Channel Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Channel_Code = Id };
            return base.GetById<Channel>(obj, RelationList);
        }
        public void Add(Channel entity)
        {
            Channel oldObj = Get(entity.Channel_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Channel entity)
        {
            Channel oldObj = Get(entity.Channel_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Channel entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Channel> GetAll()
        {
            return base.GetAll<Channel>();
        }
        public IEnumerable<Channel> SearchFor(object param)
        {
            return base.SearchForEntity<Channel>(param);
        }
    }
    public class Entity_Repository : MainRepository<RightsU_Dapper.Entity.Master_Entities.Entity>
    {
        public RightsU_Dapper.Entity.Master_Entities.Entity Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Entity_Code = Id };
            return base.GetById<RightsU_Dapper.Entity.Master_Entities.Entity>(obj, RelationList);
        }
        public void Add(RightsU_Dapper.Entity.Master_Entities.Entity entity)
        {
            RightsU_Dapper.Entity.Master_Entities.Entity oldObj = Get(entity.Entity_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(RightsU_Dapper.Entity.Master_Entities.Entity entity)
        {
            RightsU_Dapper.Entity.Master_Entities.Entity oldObj = Get(entity.Entity_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(RightsU_Dapper.Entity.Master_Entities.Entity entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<RightsU_Dapper.Entity.Master_Entities.Entity> GetAll()
        {
            return base.GetAll<RightsU_Dapper.Entity.Master_Entities.Entity>();
        }
        public IEnumerable<RightsU_Dapper.Entity.Master_Entities.Entity> SearchFor(object param)
        {
            return base.SearchForEntity<RightsU_Dapper.Entity.Master_Entities.Entity>(param);
        }
    }
    public class Payment_Terms_Repository : MainRepository<Payment_Term>
    {
        public Payment_Term Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Payment_Terms_Code = Id };
            return base.GetById<Payment_Term>(obj, RelationList);
        }
        public void Add(Payment_Term entity)
        {
            Payment_Term oldObj = Get(entity.Payment_Terms_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Payment_Term entity)
        {
            Payment_Term oldObj = Get(entity.Payment_Terms_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Payment_Term entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Payment_Term> GetAll()
        {
            return base.GetAll<Payment_Term>();
        }
        public IEnumerable<Payment_Term> SearchFor(object param)
        {
            return base.SearchForEntity<Payment_Term>(param);
        }
    }
    public class Royalty_Recoupment_Repository : MainRepository<Royalty_Recoupment>
    {
        public Royalty_Recoupment Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Royalty_Recoupment_Code = Id };
            return base.GetById<Royalty_Recoupment>(obj, RelationList);
        }
        public void Add(Royalty_Recoupment entity)
        {
            Royalty_Recoupment oldObj = Get(entity.Royalty_Recoupment_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Royalty_Recoupment entity)
        {
            Royalty_Recoupment oldObj = Get(entity.Royalty_Recoupment_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Royalty_Recoupment entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Royalty_Recoupment> GetAll()
        {
            return base.GetAll<Royalty_Recoupment>();
        }
        public IEnumerable<Royalty_Recoupment> SearchFor(object param)
        {
            return base.SearchForEntity<Royalty_Recoupment>(param);
        }
    }
    public class Royalty_Recoupment_Details_Repository : MainRepository<Royalty_Recoupment_Details>
    {
        public Royalty_Recoupment_Details Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Royalty_Recoupment_Details_Code = Id };
            return base.GetById<Royalty_Recoupment_Details>(obj, RelationList);
        }
        public void Add(Royalty_Recoupment_Details entity)
        {
            Royalty_Recoupment_Details oldObj = Get(entity.Royalty_Recoupment_Details_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Royalty_Recoupment_Details entity)
        {
            Royalty_Recoupment_Details oldObj = Get(entity.Royalty_Recoupment_Details_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Royalty_Recoupment_Details entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Royalty_Recoupment_Details> GetAll()
        {
            return base.GetAll<Royalty_Recoupment_Details>();
        }
        public IEnumerable<Royalty_Recoupment_Details> SearchFor(object param)
        {
            return base.SearchForEntity<Royalty_Recoupment_Details>(param);
        }
    }
    public class User_Repository : MainRepository<User>
    {
        public User Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Users_Code = Id };
            return base.GetById<User>(obj, RelationList);
        }
        public void Add(User entity)
        {
            User oldObj = Get(entity.Users_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(User entity)
        {
            User oldObj = Get(entity.Users_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(User entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<User> GetAll()
        {
            return base.GetAll<User>();
        }
        public IEnumerable<User> SearchFor(object param)
        {
            return base.SearchForEntity<User>(param);
        }
    }
    public class Users_Exclusion_Rights_Repository : MainRepository<Users_Exclusion_Rights>
    {
        public Users_Exclusion_Rights Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Users_Exclusion_Rights_Code = Id };
            return base.GetById<Users_Exclusion_Rights>(obj, RelationList);
        }
        public void Add(Users_Exclusion_Rights entity)
        {
            Users_Exclusion_Rights oldObj = Get(entity.Users_Exclusion_Rights_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Users_Exclusion_Rights entity)
        {
            Users_Exclusion_Rights oldObj = Get(entity.Users_Exclusion_Rights_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Users_Exclusion_Rights entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Users_Exclusion_Rights> GetAll()
        {
            return base.GetAll<Users_Exclusion_Rights>();
        }
        public IEnumerable<Users_Exclusion_Rights> SearchFor(object param)
        {
            return base.SearchForEntity<Users_Exclusion_Rights>(param);
        }
    }
    public class Business_Unit_Repository : MainRepository<Business_Unit>
    {
        public Business_Unit Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Business_Unit_Code = Id };
            return base.GetById<Business_Unit>(obj, RelationList);
        }
        public void Add(Business_Unit entity)
        {
            Business_Unit oldObj = Get(entity.Business_Unit_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Business_Unit entity)
        {
            Business_Unit oldObj = Get(entity.Business_Unit_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Business_Unit entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Business_Unit> GetAll()
        {
            return base.GetAll<Business_Unit>();
        }
        public IEnumerable<Business_Unit> SearchFor(object param)
        {
            return base.SearchForEntity<Business_Unit>(param);
        }
    }
    public class Users_Password_Detail_Repository : MainRepository<Users_Password_Detail>
    {
        public Users_Password_Detail Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Users_Password_Detail_Code = Id };
            return base.GetById<Users_Password_Detail>(obj, RelationList);
        }
        public void Add(Users_Password_Detail entity)
        {
            Users_Password_Detail oldObj = Get(entity.Users_Password_Detail_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Users_Password_Detail entity)
        {
            Users_Password_Detail oldObj = Get(entity.Users_Password_Detail_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Users_Password_Detail entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Users_Password_Detail> GetAll()
        {
            return base.GetAll<Users_Password_Detail>();
        }
        public IEnumerable<Users_Password_Detail> SearchFor(object param)
        {
            return base.SearchForEntity<Users_Password_Detail>(param);
        }
    }
    public class SAP_WBS_Repository : MainRepository<SAP_WBS>
    {
        public SAP_WBS Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { SAP_WBS_Code = Id };
            return base.GetById<SAP_WBS>(obj, RelationList);
        }
        public void Add(SAP_WBS entity)
        {
            SAP_WBS oldObj = Get(entity.SAP_WBS_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(SAP_WBS entity)
        {
            SAP_WBS oldObj = Get(entity.SAP_WBS_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(SAP_WBS entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<SAP_WBS> GetAll()
        {
            return base.GetAll<SAP_WBS>();
        }
        public IEnumerable<SAP_WBS> SearchFor(object param)
        {
            return base.SearchForEntity<SAP_WBS>(param);
        }
    }
    public class BVException_Repository : MainRepository<BVException>
    {
        public BVException Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Bv_Exception_Code = Id };
            return base.GetById<BVException>(obj, RelationList);
        }
        public void Add(BVException entity)
        {
            BVException oldObj = Get(entity.Bv_Exception_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(BVException entity)
        {
            BVException oldObj = Get(entity.Bv_Exception_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(BVException entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<BVException> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<BVException>(RelationList);
        }
        public IEnumerable<BVException> SearchFor(object param)
        {
            return base.SearchForEntity<BVException>(param);
        }
    }
    public class System_Language_Repository : MainRepository<System_Language>
    {
        public System_Language Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { System_Language_Code = Id };
            return base.GetById<System_Language>(obj, RelationList);
        }
        public void Add(System_Language entity)
        {
            System_Language oldObj = Get(entity.System_Language_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(System_Language entity)
        {
            System_Language oldObj = Get(entity.System_Language_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(System_Language entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<System_Language> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<System_Language>(RelationList);
        }
        public IEnumerable<System_Language> SearchFor(object param)
        {
            return base.SearchForEntity<System_Language>(param);
        }
    }
    public class System_Module_Message_Repository : MainRepository<System_Module_Message>
    {
        public System_Module_Message Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { System_Module_Message_Code = Id };
            return base.GetById<System_Module_Message>(obj, RelationList);
        }
        public void Add(System_Module_Message entity)
        {
            System_Module_Message oldObj = Get(entity.System_Module_Message_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(System_Module_Message entity)
        {
            System_Module_Message oldObj = Get(entity.System_Module_Message_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(System_Module_Message entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<System_Module_Message> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<System_Module_Message>(RelationList);
        }
        public IEnumerable<System_Module_Message> SearchFor(object param)
        {
            return base.SearchForEntity<System_Module_Message>(param);
        }
    }
    public class System_Module_Repository : MainRepository<System_Module>
    {
        public System_Module Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Module_Code = Id };
            return base.GetById<System_Module>(obj, RelationList);
        }
        public void Add(System_Module entity)
        {
            System_Module oldObj = Get(entity.Module_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(System_Module entity)
        {
            System_Module oldObj = Get(entity.Module_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(System_Module entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<System_Module> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<System_Module>(RelationList);
        }
        public IEnumerable<System_Module> SearchFor(object param)
        {
            return base.SearchForEntity<System_Module>(param);
        }
    }
    public class USP_GetSystem_Language_Message_ByModule_Repository : ProcRepository
    {
        public IEnumerable<USP_GetSystem_Language_Message_ByModule_Result> USP_GetSystem_Language_Message_ByModule(Nullable<int> module_Code, string form_ID, Nullable<int> system_Language_Code)
        {
            var param = new DynamicParameters();


            param.Add("@Module_Code", module_Code);
            param.Add("@Form_ID", form_ID);
            param.Add("@System_Language_Code", system_Language_Code);

            return base.ExecuteSQLProcedure<USP_GetSystem_Language_Message_ByModule_Result>("USP_GetSystem_Language_Message_ByModule", param);

        }
    }
    public class Workflow_Module_Repository : MainRepository<Workflow_Module>
    {
        public Workflow_Module Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Workflow_Module_Code = Id };
            return base.GetById<Workflow_Module>(obj, RelationList);
        }
        public void Add(Workflow_Module entity)
        {
            Workflow_Module oldObj = Get(entity.Workflow_Module_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Workflow_Module entity)
        {
            Workflow_Module oldObj = Get(entity.Workflow_Module_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Workflow_Module entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Workflow_Module> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<Workflow_Module>(RelationList);
        }
        public IEnumerable<Workflow_Module> SearchFor(object param)
        {
            return base.SearchForEntity<Workflow_Module>(param);
        }
    }
    public class Workflow_Repository : MainRepository<Workflow>
    {
        public Workflow Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Workflow_Code = Id };
            return base.GetById<Workflow>(obj, RelationList);
        }
        public void Add(Workflow entity)
        {
            Workflow oldObj = Get(entity.Workflow_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Workflow entity)
        {
            Workflow oldObj = Get(entity.Workflow_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Workflow entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Workflow> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<Workflow>(RelationList);
        }
        public IEnumerable<Workflow> SearchFor(object param)
        {
            return base.SearchForEntity<Workflow>(param);
        }
    }
    public class Workflow_Role_Repository : MainRepository<Workflow_Role>
    {
        public Workflow_Role Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Workflow_Role_Code = Id };
            return base.GetById<Workflow_Role>(obj, RelationList);
        }
        public void Add(Workflow_Role entity)
        {
            Workflow_Role oldObj = Get(entity.Workflow_Role_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Workflow_Role entity)
        {
            Workflow_Role oldObj = Get(entity.Workflow_Role_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Workflow_Role entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Workflow_Role> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<Workflow_Role>(RelationList);
        }
        public IEnumerable<Workflow_Role> SearchFor(object param)
        {
            return base.SearchForEntity<Workflow_Role>(param);
        }
    }
    public class Workflow_Module_Role_Repository : MainRepository<Workflow_Module_Role>
    {
        public Workflow_Module_Role Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Workflow_Module_Role_Code = Id };
            return base.GetById<Workflow_Module_Role>(obj, RelationList);
        }
        public void Add(Workflow_Module_Role entity)
        {
            Workflow_Module_Role oldObj = Get(entity.Workflow_Module_Role_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Workflow_Module_Role entity)
        {
            Workflow_Module_Role oldObj = Get(entity.Workflow_Module_Role_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Workflow_Module_Role entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Workflow_Module_Role> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<Workflow_Module_Role>(RelationList);
        }
        public IEnumerable<Workflow_Module_Role> SearchFor(object param)
        {
            return base.SearchForEntity<Workflow_Module_Role>(param);
        }
    }
    public class Users_Business_Unit_Repository : MainRepository<Users_Business_Unit>
    {
        public Users_Business_Unit Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Users_Business_Unit_Code = Id };
            return base.GetById<Users_Business_Unit>(obj, RelationList);
        }
        public void Add(Users_Business_Unit entity)
        {
            Users_Business_Unit oldObj = Get(entity.Users_Business_Unit_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Users_Business_Unit entity)
        {
            Users_Business_Unit oldObj = Get(entity.Users_Business_Unit_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Users_Business_Unit entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Users_Business_Unit> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<Users_Business_Unit>(RelationList);
        }
        public IEnumerable<Users_Business_Unit> SearchFor(object param)
        {
            return base.SearchForEntity<Users_Business_Unit>(param);
        }
    }
    public class BV_HouseId_Data_Repository : MainRepository<BV_HouseId_Data>
    {
        public BV_HouseId_Data Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { BV_HouseId_Data_Code = Id };
            return base.GetById<BV_HouseId_Data>(obj, RelationList);
        }
        public void Add(BV_HouseId_Data entity)
        {
            BV_HouseId_Data oldObj = Get(entity.BV_HouseId_Data_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(BV_HouseId_Data entity)
        {
            BV_HouseId_Data oldObj = Get(entity.BV_HouseId_Data_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(BV_HouseId_Data entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<BV_HouseId_Data> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<BV_HouseId_Data>(RelationList);
        }
        public IEnumerable<BV_HouseId_Data> SearchFor(object param)
        {
            return base.SearchForEntity<BV_HouseId_Data>(param);
        }
    }
    public class USP_Validate_Episode_Repository : ProcRepository
    {
        public IEnumerable<USP_Validate_Episode_Result> USP_Validate_Episode(string title_with_Episode, string Program_Type)
        {
            var param = new DynamicParameters();

            param.Add("@Title_with_Episode", title_with_Episode);
            param.Add("@Program_Type", Program_Type);

            return base.ExecuteSQLProcedure<USP_Validate_Episode_Result>("USP_Validate_Episode", param);

        }
    }
    public class USP_UpdateContentHouseID_Repository : ProcRepository
    {
        public void USP_UpdateContentHouseID(Nullable<int> BV_HouseId_Data_Code, Nullable<int> MappedDealTitleCode)
        {
            var param = new DynamicParameters();

            param.Add("@BV_HouseId_Data_Code", BV_HouseId_Data_Code);
            param.Add("@MappedDealTitleCode", MappedDealTitleCode);

            base.ExecuteScalar("USP_UpdateContentHouseID", param);
        }
    }
    public class BMS_Log_Repository : MainRepository<BMS_Log>
    {
        public BMS_Log Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { BMS_Log_Code = Id };
            return base.GetById<BMS_Log>(obj, RelationList);
        }
        public void Add(BMS_Log entity)
        {
            BMS_Log oldObj = Get(entity.BMS_Log_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(BMS_Log entity)
        {
            BMS_Log oldObj = Get(entity.BMS_Log_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(BMS_Log entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<BMS_Log> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<BMS_Log>(RelationList);
        }
        public IEnumerable<BMS_Log> SearchFor(object param)
        {
            return base.SearchForEntity<BMS_Log>(param);
        }
    }
    public class BMS_All_Masters_Repository : MainRepository<BMS_All_Masters>
    {
        public BMS_All_Masters Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Order_Id = Id };
            return base.GetById<BMS_All_Masters>(obj, RelationList);
        }
        public void Add(BMS_All_Masters entity)
        {
            BMS_All_Masters oldObj = Get(entity.Order_Id);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(BMS_All_Masters entity)
        {
            BMS_All_Masters oldObj = Get(entity.Order_Id);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(BMS_All_Masters entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<BMS_All_Masters> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<BMS_All_Masters>(RelationList);
        }
    }
    public class USP_List_BMS_log_Repository : ProcRepository
    {
        public IEnumerable<USP_List_BMS_log_Result> USP_List_BMS_log(string strSearch, Nullable<int> pageNo, string isPaging, Nullable<int> pageSize, out int recordCount)
        {
            var param = new DynamicParameters();

            param.Add("@StrSearch", strSearch);
            param.Add("@PageNo", pageNo);
            param.Add("@IsPaging", isPaging);
            param.Add("@PageSize", pageSize);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);

            IEnumerable<USP_List_BMS_log_Result> lstUSP_List_BMS_log_Result = base.ExecuteSQLProcedure<USP_List_BMS_log_Result>("USP_List_BMS_log", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_List_BMS_log_Result;
        }
    }
    public class Amort_Rule_Repository : MainRepository<Amort_Rule>
    {
        public Amort_Rule Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Amort_Rule_Code = Id };
            return base.GetById<Amort_Rule>(obj, RelationList);
        }
        public void Add(Amort_Rule entity)
        {
            Amort_Rule oldObj = Get(entity.Amort_Rule_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Amort_Rule entity)
        {
            Amort_Rule oldObj = Get(entity.Amort_Rule_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Amort_Rule entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Amort_Rule> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<Amort_Rule>(RelationList);
        }
    }
    public class USP_List_Amort_Rule_Repository : ProcRepository
    {
        public IEnumerable<USP_List_Amort_Rule_Result> USP_List_Amort_Rule(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, out int recordCount, Nullable<int> user_Code, string moduleCode)
        {
            var param = new DynamicParameters();

            param.Add("@StrSearch", strSearch);
            param.Add("@PageNo", pageNo);
            param.Add("@OrderByCndition", orderByCndition);
            param.Add("@IsPaging", isPaging);
            param.Add("@PageSize", pageSize);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            param.Add("@User_Code", user_Code);
            param.Add("@ModuleCode", moduleCode);

            IEnumerable<USP_List_Amort_Rule_Result> lstUSP_List_Amort_Rule_Result = base.ExecuteSQLProcedure<USP_List_Amort_Rule_Result>("USP_List_Amort_Rule", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSP_List_Amort_Rule_Result;
        }
    }
    public class USPBindJobAndExecute_Repository : ProcRepository
    {
        public IEnumerable<USPBindJobAndExecute_Result> USPBindJobAndExecute(string type, string jobName)
        {
            var param = new DynamicParameters();

            param.Add("@Type", type);
            param.Add("@JobName", jobName);

            return base.ExecuteSQLProcedure<USPBindJobAndExecute_Result>("USPBindJobAndExecute", param);

        }
    }
    public class USPRUBVMappingList_Repository : ProcRepository
    {
        public IEnumerable<USPRUBVMappingList_Result> USPRUBVMappingList(string dropdownOption, string tabselect, Nullable<int> pageNo, Nullable<int> pageSize,out int recordCount)
        {
            var param = new DynamicParameters();

            param.Add("@DropdownOption", dropdownOption);
            param.Add("@Tabselect", tabselect);
            param.Add("@PageNo", pageNo);
            param.Add("@PageSize", pageSize);
            param.Add("@RecordCount", dbType: DbType.Int32, direction: ParameterDirection.Output);


            IEnumerable<USPRUBVMappingList_Result> lstUSPRUBVMappingList_Result = base.ExecuteSQLProcedure<USPRUBVMappingList_Result>("USPRUBVMappingList", param);
            recordCount = param.Get<int>("@RecordCount");
            return lstUSPRUBVMappingList_Result;

        }
    }
    public class BMS_Asset_Repository : MainRepository<BMS_Asset>
    {
        public BMS_Asset Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { BMS_Asset_Code = Id };
            return base.GetById<BMS_Asset>(obj, RelationList);
        }
        public void Add(BMS_Asset entity)
        {
            BMS_Asset oldObj = Get(entity.BMS_Asset_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(BMS_Asset entity)
        {
            BMS_Asset oldObj = Get(entity.BMS_Asset_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(BMS_Asset entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<BMS_Asset> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<BMS_Asset>(RelationList);
        }
    }
    public class BMS_Deal_Content_Repository : MainRepository<BMS_Deal_Content>
    {
        public BMS_Deal_Content Get(decimal? Id, Type[] RelationList = null)
        {
            var obj = new { BMS_Deal_Content_Code = Id };
            return base.GetById<BMS_Deal_Content>(obj, RelationList);
        }
        public void Add(BMS_Deal_Content entity)
        {
            BMS_Deal_Content oldObj = Get(entity.BMS_Deal_Content_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(BMS_Deal_Content entity)
        {
            BMS_Deal_Content oldObj = Get(entity.BMS_Deal_Content_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(BMS_Deal_Content entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<BMS_Deal_Content> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<BMS_Deal_Content>(RelationList);
        }
    }

    public class BMS_Deal_Content_Rights_Repository : MainRepository<BMS_Deal_Content_Rights>
    {
        public BMS_Deal_Content_Rights Get(decimal? Id, Type[] RelationList = null)
        {
            var obj = new { BMS_Deal_Content_Rights_Code = Id };
            return base.GetById<BMS_Deal_Content_Rights>(obj, RelationList);
        }
        public void Add(BMS_Deal_Content_Rights entity)
        {
            BMS_Deal_Content_Rights oldObj = Get(entity.BMS_Deal_Content_Rights_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(BMS_Deal_Content_Rights entity)
        {
            BMS_Deal_Content_Rights oldObj = Get(entity.BMS_Deal_Content_Rights_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(BMS_Deal_Content_Rights entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<BMS_Deal_Content_Rights> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<BMS_Deal_Content_Rights>(RelationList);
        }
    }
    public class BMS_Deal_Repository : MainRepository<BMS_Deal>
    {
        public BMS_Deal Get(decimal? Id, Type[] RelationList = null)
        {
            var obj = new { BMS_Deal_Code = Id };
            return base.GetById<BMS_Deal>(obj, RelationList);
        }
        public void Add(BMS_Deal entity)
        {
            BMS_Deal oldObj = Get(entity.BMS_Deal_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(BMS_Deal entity)
        {
            BMS_Deal oldObj = Get(entity.BMS_Deal_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(BMS_Deal entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<BMS_Deal> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<BMS_Deal>(RelationList);
        }
    }
    public class Music_Language_Repository : MainRepository<Music_Language>
    {
        public Music_Language Get(decimal? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Language_Code = Id };
            return base.GetById<Music_Language>(obj, RelationList);
        }
        public void Add(Music_Language entity)
        {
            Music_Language oldObj = Get(entity.Music_Language_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Music_Language entity)
        {
            Music_Language oldObj = Get(entity.Music_Language_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Language entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Music_Language> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<Music_Language>(RelationList);
        }
    }

    
}