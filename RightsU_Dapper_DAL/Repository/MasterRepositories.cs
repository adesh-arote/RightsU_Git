using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
using RightsU_Dapper.Entity.Master_Entities;
//using RightsU_Dapper.Entity.StoredProcedure_Entities;
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

    //public class Music_Deal_Platform_Repository : MainRepository<Music_Deal_Platform_Dapper>
    //{
    //    public void DeleteAll(List<Music_Deal_Platform_Dapper> ListEntity)
    //    {
    //        base.DeleteAllEntity(ListEntity);
    //    }
    //}
    public class Vendor_Repository : MainRepository<Vendor>
    {
        public Vendor Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Vendor_Code = Id };
            return base.GetById<Vendor>(obj, RelationList);
        }
        public void Add(Vendor entity)
        {
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
        public IEnumerable<Party_Category> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Party_Category>(additionalTypes);
        }
        public void Add(Party_Category entity)
        {
            Party_Category oldObj = Get(entity.Party_Category_Code);
            base.UpdateEntity(oldObj, entity);
            //base.AddEntity(entity);
        }
        public void Update(Party_Category entity)
        {
            Party_Category oldObj = Get(entity.Party_Category_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Party_Category entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Party_Category> SearchFor(object param)
        {
            return base.SearchForEntity<Party_Category>(param);
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
    //public class Language_Repository : MainRepository<Language>
    //{
    //    public Language Get(int? Id, Type[] RelationList = null)
    //    {
    //        var obj = new { Language_Code = Id };
    //        return base.GetById<Language>(obj, RelationList);
    //    }
    //    public void Add(Language entity)
    //    {
    //        Language oldObj = Get(entity.Language_Code);
    //        // base.UpdateEntity(oldObj, entity);
    //        base.AddEntity(entity);
    //    }
    //    public void Update(Language entity)
    //    {
    //        Language oldObj = Get(entity.Language_Code);
    //        base.UpdateEntity(oldObj, entity);
    //    }
    //    public void Delete(Language entity)
    //    {
    //        base.DeleteEntity(entity);
    //    }
    //    public IEnumerable<Language> GetAll()
    //    {
    //        return base.GetAll<Language>();
    //    }
    //    public IEnumerable<Language> SearchFor(object param)
    //    {
    //        return base.SearchForEntity<Language>(param);
    //    }
    //}
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
    //public class Role_Repository : MainRepository<Role>
    //{
    //    public Role Get(int? Id, Type[] RelationList = null)
    //    {
    //        var obj = new { Role_Code = Id };
    //        return base.GetById<Role>(obj, RelationList);
    //    }
    //    public void Add(Role entity)
    //    {
    //        Role oldObj = Get(entity.Role_Code);
    //        // base.UpdateEntity(oldObj, entity);
    //        base.AddEntity(entity);
    //    }
    //    public void Update(Role entity)
    //    {
    //        Role oldObj = Get(entity.Role_Code);
    //        base.UpdateEntity(oldObj, entity);
    //    }
    //    public void Delete(Role entity)
    //    {
    //        base.DeleteEntity(entity);
    //    }
    //    public IEnumerable<Role> GetAll()
    //    {
    //        return base.GetAll<Role>();
    //    }
    //    public IEnumerable<Role> SearchFor(object param)
    //    {
    //        return base.SearchForEntity<Role>(param);
    //    }
    //}
    //public class Channel_Repository : MainRepository<Channel>
    //{
    //    public Channel Get(int? Id, Type[] RelationList = null)
    //    {
    //        var obj = new { Channel_Code = Id };
    //        return base.GetById<Channel>(obj, RelationList);
    //    }
    //    public void Add(Channel entity)
    //    {
    //        Channel oldObj = Get(entity.Channel_Code);
    //        // base.UpdateEntity(oldObj, entity);
    //        base.AddEntity(entity);
    //    }
    //    public void Update(Channel entity)
    //    {
    //        Channel oldObj = Get(entity.Channel_Code);
    //        base.UpdateEntity(oldObj, entity);
    //    }
    //    public void Delete(Channel entity)
    //    {
    //        base.DeleteEntity(entity);
    //    }
    //    public IEnumerable<Channel> GetAll()
    //    {
    //        return base.GetAll<Channel>();
    //    }
    //    public IEnumerable<Channel> SearchFor(object param)
    //    {
    //        return base.SearchForEntity<Channel>(param);
    //    }
    //}
    public class Entity_Repository : MainRepository<RightsU_Dapper.Entity.Entity>
    {
        public RightsU_Dapper.Entity.Entity Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Entity_Code = Id };
            return base.GetById<RightsU_Dapper.Entity.Entity>(obj, RelationList);
        }
        public void Add(RightsU_Dapper.Entity.Entity entity)
        {
            RightsU_Dapper.Entity.Entity oldObj = Get(entity.Entity_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(RightsU_Dapper.Entity.Entity entity)
        {
            RightsU_Dapper.Entity.Entity oldObj = Get(entity.Entity_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(RightsU_Dapper.Entity.Entity entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<RightsU_Dapper.Entity.Entity> GetAll()
        {
            return base.GetAll<RightsU_Dapper.Entity.Entity>();
        }
        public IEnumerable<RightsU_Dapper.Entity.Entity> SearchFor(object param)
        {
            return base.SearchForEntity<RightsU_Dapper.Entity.Entity>(param);
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
    //public class User_Repository : MainRepository<User>
    //{
    //    public User Get(int? Id, Type[] RelationList = null)
    //    {
    //        var obj = new { Users_Code = Id };
    //        return base.GetById<User>(obj, RelationList);
    //    }
    //    public void Add(User entity)
    //    {
    //        User oldObj = Get(entity.Users_Code);
    //        // base.UpdateEntity(oldObj, entity);
    //        base.AddEntity(entity);
    //    }
    //    public void Update(User entity)
    //    {
    //        User oldObj = Get(entity.Users_Code);
    //        base.UpdateEntity(oldObj, entity);
    //    }
    //    public void Delete(User entity)
    //    {
    //        base.DeleteEntity(entity);
    //    }
    //    public IEnumerable<User> GetAll()
    //    {
    //        return base.GetAll<User>();
    //    }
    //    public IEnumerable<User> SearchFor(object param)
    //    {
    //        return base.SearchForEntity<User>(param);
    //    }
    //}
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
    //public class Business_Unit_Repository : MainRepository<Business_Unit>
    //{
    //    public Business_Unit Get(int? Id, Type[] RelationList = null)
    //    {
    //        var obj = new { Business_Unit_Code = Id };
    //        return base.GetById<Business_Unit>(obj, RelationList);
    //    }
    //    public void Add(Business_Unit entity)
    //    {
    //        Business_Unit oldObj = Get(entity.Business_Unit_Code);
    //        // base.UpdateEntity(oldObj, entity);
    //        base.AddEntity(entity);
    //    }
    //    public void Update(Business_Unit entity)
    //    {
    //        Business_Unit oldObj = Get(entity.Business_Unit_Code);
    //        base.UpdateEntity(oldObj, entity);
    //    }
    //    public void Delete(Business_Unit entity)
    //    {
    //        base.DeleteEntity(entity);
    //    }
    //    public IEnumerable<Business_Unit> GetAll()
    //    {
    //        return base.GetAll<Business_Unit>();
    //    }
    //    public IEnumerable<Business_Unit> SearchFor(object param)
    //    {
    //        return base.SearchForEntity<Business_Unit>(param);
    //    }
    //}
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

    public class Music_Deal_Platform_Repository : MainRepository<Music_Deal_Platform_Dapper>
    {
        public void DeleteAll(List<Music_Deal_Platform_Dapper> ListEntity)
        {
            base.DeleteAllEntity(ListEntity);
        }
    }
    public class Talent_Repository : MainRepository<Talent>
    {
        public Talent Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Talent_Code = Id };
            return base.GetById<Talent>(obj, RelationList);
        }
        public void Add(Talent entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Talent entity)
        {
            Talent oldObj = Get(entity.Talent_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Talent entity)
        {
            base.DeleteEntity(entity);
        }

        public IEnumerable<Talent> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Talent>();
        }
        public IEnumerable<Talent> SearchFor(object param)
        {
            return base.SearchForEntity<Talent>(param);
        }
    }
    public class Role_Repository : MainRepository<Role>
    {
        //public Role_Repository(string conStr) : base(conStr) { }
        public IEnumerable<Role> SearchFor(object param)
        {
            return base.SearchForEntity<Role>(param);
        }
        public Role Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Role_Code = Id };
            return base.GetById<Role>(obj, RelationList);
        }
        public IEnumerable<Role> GetAll()
        {
            return base.GetAll<Role>();
        }
    }
    public class Language_Group_Repository : MainRepository<Language_Group>
    {
        public Language_Group Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Language_Group_Code = Id };
            return base.GetById<Language_Group>(obj, RelationList);
        }
        public void Add(Language_Group entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Language_Group entity)
        {
            Language_Group oldObj = Get(entity.Language_Group_Code,new Type[] { typeof(Language_Group_Details) });
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Language_Group entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Language_Group> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Language_Group>(additionalTypes);
        }
        public IEnumerable<Language_Group> SearchFor(object param)
        {
            return base.SearchForEntity<Language_Group>(param);
        }
    }
    public class Language_Repository : MainRepository<Language>
    {
        // public Language_Repository(string conStr) : base(conStr) { }
        public Language Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Language_Code = Id };
            return base.GetById<Language>(obj, RelationList);
        }
        public void Add(Language entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
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
        public IEnumerable<Language> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Language>(additionalTypes);
        }
        public IEnumerable<Language> SearchFor(object param)
        {
            return base.SearchForEntity<Language>(param);
        }
    }
    public class Promoter_Remarks_Repository : MainRepository<Promoter_Remarks>
    {
        // public Promoter_Remarks_Repository(string conStr) : base(conStr) { }

        //public override void Save(Promoter_Remarks objToSave)
        //{
        //    if (objToSave.EntityState == State.Added)
        //    {
        //        base.Save(objToSave);
        //    }
        //    else if (objToSave.EntityState == State.Modified)
        //    {
        //        base.Update(objToSave);
        //    }
        //    else if (objToSave.EntityState == State.Deleted)
        //    {
        //        base.Delete(objToSave);
        //    }
        //}
        public IEnumerable<Promoter_Remarks> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Promoter_Remarks>();
        }
        public IEnumerable<Promoter_Remarks> SearchFor(object param)
        {
            return base.SearchForEntity<Promoter_Remarks>(param);
        }
        public Promoter_Remarks Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Promoter_Remarks_Code = Id };
            return base.GetById<Promoter_Remarks>(obj, RelationList);
        }
        public void Add(Promoter_Remarks entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Promoter_Remarks entity)
        {
            Promoter_Remarks oldObj = Get(entity.Promoter_Remarks_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Promoter_Remarks entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Grade_Master_Repository : MainRepository<Grade_Master>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Grade_Master> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Grade_Master>();
        }
        public IEnumerable<Grade_Master> SearchFor(object param)
        {
            return base.SearchForEntity<Grade_Master>(param);
        }
        public Grade_Master Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Grade_Code = Id };
            return base.GetById<Grade_Master>(obj, RelationList);
        }
        public void Add(Grade_Master entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Grade_Master entity)
        {
            Grade_Master oldObj = Get(entity.Grade_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Grade_Master entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Currency_Repository : MainRepository<Currency>
    {
        public IEnumerable<Currency> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Currency>();
        }
        public IEnumerable<Currency> SearchFor(object param)
        {
            return base.SearchForEntity<Currency>(param);
        }
        public Currency Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Currency_Code = Id };
            return base.GetById<Currency>(obj, RelationList);
        }
        public void Add(Currency entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Currency entity)
        {
            Currency oldObj = Get(entity.Currency_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Currency entity)
        {
            base.DeleteEntity(entity);
        }
        //public override void Save(Currency objCurrency)
        //{
        //    Save_Master_Entities_Generic objSaveEntities = new Save_Master_Entities_Generic();
        //    if (objCurrency.Currency_Exchange_Rate != null) objCurrency.Currency_Exchange_Rate = objSaveEntities.SaveCurrencyExchangeRate(objCurrency.Currency_Exchange_Rate, base.DataContext);

        //    if (objCurrency.EntityState == State.Added)
        //    {
        //        base.Save(objCurrency);
        //    }
        //    else if (objCurrency.EntityState == State.Modified)
        //    {
        //        base.Update(objCurrency);
        //    }
        //    else if (objCurrency.EntityState == State.Deleted)
        //    {
        //        base.Delete(objCurrency);
        //    }
        //}
    }
    public class Genres_Repository : MainRepository<Genre>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Genre> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Genre>();
        }
        public IEnumerable<Genre> SearchFor(object param)
        {
            return base.SearchForEntity<Genre>(param);
        }
        public Genre Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Genres_Code = Id };
            return base.GetById<Genre>(obj, RelationList);
        }
        public void Add(Genre entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Genre entity)
        {
            Genre oldObj = Get(entity.Genres_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Genre entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Cost_Type_Repository : MainRepository<Cost_Type>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Cost_Type> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Cost_Type>();
        }
        public IEnumerable<Cost_Type> SearchFor(object param)
        {
            return base.SearchForEntity<Cost_Type>(param);
        }
        public Cost_Type Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Cost_Type_Code = Id };
            return base.GetById<Cost_Type>(obj, RelationList);
        }
        public void Add(Cost_Type entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Cost_Type entity)
        {
            Cost_Type oldObj = Get(entity.Cost_Type_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Cost_Type entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Document_Type_Repository : MainRepository<Document_Type>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Document_Type> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Document_Type>();
        }
        public IEnumerable<Document_Type> SearchFor(object param)
        {
            return base.SearchForEntity<Document_Type>(param);
        }
        public Document_Type Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Document_Type_Code = Id };
            return base.GetById<Document_Type>(obj, RelationList);
        }
        public void Add(Document_Type entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Document_Type entity)
        {
            Document_Type oldObj = Get(entity.Document_Type_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Document_Type entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Right_Rule_Repository : MainRepository<Right_Rule>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Right_Rule> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Right_Rule>();
        }
        public IEnumerable<Right_Rule> SearchFor(object param)
        {
            return base.SearchForEntity<Right_Rule>(param);
        }
        public Right_Rule Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Right_Rule_Code = Id };
            return base.GetById<Right_Rule>(obj, RelationList);
        }
        public void Add(Right_Rule entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Right_Rule entity)
        {
            Right_Rule oldObj = Get(entity.Right_Rule_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Right_Rule entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Material_Medium_Repository : MainRepository<Material_Medium>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Material_Medium> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Material_Medium>();
        }
        public IEnumerable<Material_Medium> SearchFor(object param)
        {
            return base.SearchForEntity<Material_Medium>(param);
        }
        public Material_Medium Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Material_Medium_Code = Id };
            return base.GetById<Material_Medium>(obj, RelationList);
        }
        public void Add(Material_Medium entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Material_Medium entity)
        {
            Material_Medium oldObj = Get(entity.Material_Medium_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Material_Medium entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Country_Repository : MainRepository<Country>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Country> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Country>();
        }
        public IEnumerable<Country> SearchFor(object param)
        {
            return base.SearchForEntity<Country>(param);
        }
        public Country Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Country_Code = Id };
            return base.GetById<Country>(obj, RelationList);
        }
        public void Add(Country entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
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
    }
    public class Material_Type_Repository : MainRepository<Material_Type>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Material_Type> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Material_Type>();
        }
        public IEnumerable<Material_Type> SearchFor(object param)
        {
            return base.SearchForEntity<Material_Type>(param);
        }
        public Material_Type Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Material_Type_Code = Id };
            return base.GetById<Material_Type>(obj, RelationList);
        }
        public void Add(Material_Type entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Material_Type entity)
        {
            Material_Type oldObj = Get(entity.Material_Type_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Material_Type entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Category_Repository : MainRepository<Category>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Category> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Category>();
        }
        public IEnumerable<Category> SearchFor(object param)
        {
            return base.SearchForEntity<Category>(param);
        }
        public Category Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Category_Code = Id };
            return base.GetById<Category>(obj, RelationList);
        }
        public void Add(Category entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Category entity)
        {
            Category oldObj = Get(entity.Category_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Category entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class System_Parameter_New_Repository : MainRepository<System_Parameter_New>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<System_Parameter_New> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<System_Parameter_New>();
        }
        public IEnumerable<System_Parameter_New> SearchFor(object param)
        {
            return base.SearchForEntity<System_Parameter_New>(param);
        }
        public System_Parameter_New Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Id = Id };
            return base.GetById<System_Parameter_New>(obj, RelationList);
        }
        public void Add(System_Parameter_New entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(System_Parameter_New entity)
        {
            System_Parameter_New oldObj = Get(entity.Id);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(System_Parameter_New entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Platform_Group_Repository : MainRepository<Platform_Group>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Platform_Group> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Platform_Group>(additionalTypes);
        }
        public IEnumerable<Platform_Group> SearchFor(object param)
        {
            return base.SearchForEntity<Platform_Group>(param);
        }
        public Platform_Group Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Platform_Group_Code = Id };
            return base.GetById<Platform_Group>(obj, RelationList);
        }
        public void Add(Platform_Group entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Platform_Group entity)
        {
            Platform_Group oldObj = Get(entity.Platform_Group_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Platform_Group entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Platform_Repository : MainRepository<Platform>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Platform> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Platform>();
        }
        public IEnumerable<Platform> SearchFor(object param)
        {
            return base.SearchForEntity<Platform>(param);
        }
        public Platform Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Platform_Code = Id };
            return base.GetById<Platform>(obj, RelationList);
        }
        public void Add(Platform entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Platform entity)
        {
            Platform oldObj = Get(entity.Platform_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Platform entity)
        {
            base.DeleteEntity(entity);
        }
    }
        public class Milestone_Nature_Repository : MainRepository<Milestone_Nature>
        {
            //public Grade_Master_Repository(string conStr) : base(conStr) { }

            public IEnumerable<Milestone_Nature> GetAll(Type[] additionalTypes = null)
            {
                return base.GetAll<Milestone_Nature>();
            }
            public IEnumerable<Milestone_Nature> SearchFor(object param)
            {
                return base.SearchForEntity<Milestone_Nature>(param);
            }
            public Milestone_Nature Get(int? Id, Type[] RelationList = null)
            {
                var obj = new { Milestone_Nature_Code = Id };
                return base.GetById<Milestone_Nature>(obj, RelationList);
            }
            public void Add(Milestone_Nature entity)
            {
                //Talent oldObj = Get(entity.Talent_Code);
                //base.UpdateEntity(oldObj, entity);
                base.AddEntity(entity);
            }
            public void Update(Milestone_Nature entity)
            {
                Milestone_Nature oldObj = Get(entity.Milestone_Nature_Code);
                base.UpdateEntity(oldObj, entity);
            }
            public void Delete(Milestone_Nature entity)
            {
                base.DeleteEntity(entity);
            }
        }
    public class Program_Repository : MainRepository<Program>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Program> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Program>(additionalTypes);
        }
        public IEnumerable<Program> SearchFor(object param)
        {
            return base.SearchForEntity<Program>(param);
        }
        public Program Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Program_Code = Id };
            return base.GetById<Program>(obj, RelationList);
        }
        public void Add(Program entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Program entity)
        {
            Program oldObj = Get(entity.Program_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Program entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Platform_Group_Details_Repository : MainRepository<Platform_Group_Details>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Platform_Group_Details> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Platform_Group_Details>();
        }
        public IEnumerable<Platform_Group_Details> SearchFor(object param)
        {
            return base.SearchForEntity<Platform_Group_Details>(param);
        }
        public Platform_Group_Details Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Platform_Group_Details_Code = Id };
            return base.GetById<Platform_Group_Details>(obj, RelationList);
        }
        public void Add(Platform_Group_Details entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Platform_Group_Details entity)
        {
            Platform_Group_Details oldObj = Get(entity.Platform_Group_Details_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Platform_Group_Details entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Deal_Type_Repository : MainRepository<Deal_Type>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Deal_Type> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Deal_Type>();
        }
        public IEnumerable<Deal_Type> SearchFor(object param)
        {
            return base.SearchForEntity<Deal_Type>(param);
        }
        public Deal_Type Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Deal_Type_Code = Id };
            return base.GetById<Deal_Type>(obj, RelationList);
        }
        public void Add(Deal_Type entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Deal_Type entity)
        {
            Deal_Type oldObj = Get(entity.Deal_Type_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Deal_Type entity)
        {
            base.DeleteEntity(entity);
        }
    }
    //public class Party_Category_Repository : MainRepository<Party_Category>
    //{
    //    //public Grade_Master_Repository(string conStr) : base(conStr) { }

    //    public IEnumerable<Party_Category> GetAll(Type[] additionalTypes = null)
    //    {
    //        return base.GetAll<Party_Category>();
    //    }
    //    public IEnumerable<Party_Category> SearchFor(object param)
    //    {
    //        return base.SearchForEntity<Party_Category>(param);
    //    }
    //    public Party_Category Get(int? Id, Type[] RelationList = null)
    //    {
    //        var obj = new { Party_Category_Code = Id };
    //        return base.GetTalentById<Party_Category>(obj, RelationList);
    //    }
    //    public void Add(Party_Category entity)
    //    {
    //        //Talent oldObj = Get(entity.Talent_Code);
    //        //base.UpdateEntity(oldObj, entity);
    //        base.AddEntity(entity);
    //    }
    //    public void Update(Party_Category entity)
    //    {
    //        Party_Category oldObj = Get(entity.Party_Category_Code);
    //        base.UpdateEntity(oldObj, entity);
    //    }
    //    public void Delete(Party_Category entity)
    //    {
    //        base.DeleteEntity(entity);
    //    }
    //}
    //public class BV_HouseId_Data_Repository : MainRepository<BV_HouseId_Data>
    //{
    //    //public Grade_Master_Repository(string conStr) : base(conStr) { }

    //    public IEnumerable<BV_HouseId_Data> GetAll(Type[] additionalTypes = null)
    //    {
    //        return base.GetAll<BV_HouseId_Data>();
    //    }
    //    public IEnumerable<BV_HouseId_Data> SearchFor(object param)
    //    {
    //        return base.SearchForEntity<BV_HouseId_Data>(param);
    //    }
    //    public BV_HouseId_Data Get(int? Id, Type[] RelationList = null)
    //    {
    //        var obj = new { BV_HouseId_Data_Code = Id };
    //        return base.GetTalentById<BV_HouseId_Data>(obj, RelationList);
    //    }
    //    public void Add(BV_HouseId_Data entity)
    //    {
    //        //Talent oldObj = Get(entity.Talent_Code);
    //        //base.UpdateEntity(oldObj, entity);
    //        base.AddEntity(entity);
    //    }
    //    public void Update(BV_HouseId_Data entity)
    //    {
    //        BV_HouseId_Data oldObj = Get(entity.BV_HouseId_Data_Code);
    //        base.UpdateEntity(oldObj, entity);
    //    }
    //    public void Delete(BV_HouseId_Data entity)
    //    {
    //        base.DeleteEntity(entity);
    //    }
    //}
    public class Acq_Deal_Movie_Repository : MainRepository<Acq_Deal_Movie>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Acq_Deal_Movie> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Acq_Deal_Movie>();
        }
        public IEnumerable<Acq_Deal_Movie> SearchFor(object param)
        {
            return base.SearchForEntity<Acq_Deal_Movie>(param);
        }
        public Acq_Deal_Movie Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Acq_Deal_Movie_Code = Id };
            return base.GetById<Acq_Deal_Movie>(obj, RelationList);
        }
        public void Add(Acq_Deal_Movie entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Acq_Deal_Movie entity)
        {
            Acq_Deal_Movie oldObj = Get(entity.Acq_Deal_Movie_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Acq_Deal_Movie entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Title_Content_Mapping_Repository : MainRepository<Title_Content_Mapping>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Title_Content_Mapping> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Title_Content_Mapping>();
        }
        public IEnumerable<Title_Content_Mapping> SearchFor(object param)
        {
            return base.SearchForEntity<Title_Content_Mapping>(param);
        }
        public Title_Content_Mapping Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Title_Content_Mapping_Code = Id };
            return base.GetById<Title_Content_Mapping>(obj, RelationList);
        }
        public void Add(Title_Content_Mapping entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Title_Content_Mapping entity)
        {
            Title_Content_Mapping oldObj = Get(entity.Title_Content_Mapping_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Title_Content_Mapping entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Email_Config_Detail_Repository : MainRepository<Email_Config_Detail>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Email_Config_Detail> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Email_Config_Detail>();
        }
        public IEnumerable<Email_Config_Detail> SearchFor(object param)
        {
            return base.SearchForEntity<Email_Config_Detail>(param);
        }
        public Email_Config_Detail Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Email_Config_Detail_Code = Id };
            return base.GetById<Email_Config_Detail>(obj, RelationList);
        }
        public void Add(Email_Config_Detail entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Email_Config_Detail entity)
        {
            Email_Config_Detail oldObj = Get(entity.Email_Config_Detail_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Email_Config_Detail entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Email_Config_Repository : MainRepository<Email_Config>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Email_Config> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Email_Config>(additionalTypes);
        }
        public IEnumerable<Email_Config> SearchFor(object param)
        {
            return base.SearchForEntity<Email_Config>(param);
        }
        public Email_Config Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Email_Config_Code = Id };
            return base.GetById<Email_Config>(obj, RelationList);
        }
        public void Add(Email_Config entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Email_Config entity)
        {
            Email_Config oldObj = Get(entity.Email_Config_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Email_Config entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Business_Unit_Repository : MainRepository<Business_Unit>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Business_Unit> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Business_Unit>();
        }
        public IEnumerable<Business_Unit> SearchFor(object param)
        {
            return base.SearchForEntity<Business_Unit>(param);
        }
        public Business_Unit Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Business_Unit_Code = Id };
            return base.GetById<Business_Unit>(obj, RelationList);
        }
        public void Add(Business_Unit entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
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
    }
    public class Channel_Repository : MainRepository<Channel>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Channel> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Channel>(additionalTypes);
        }
        public IEnumerable<Channel> SearchFor(object param)
        {
            return base.SearchForEntity<Channel>(param);
        }
        public Channel Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Channel_Code = Id };
            return base.GetById<Channel>(obj, RelationList);
        }
        public void Add(Channel entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
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
    }
    public class User_Repository : MainRepository<User>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<User> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<User>();
        }
        public IEnumerable<User> SearchFor(object param)
        {
            return base.SearchForEntity<User>(param);
        }
        public User Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Users_Code = Id };
            return base.GetById<User>(obj, RelationList);
        }
        public void Add(User entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
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
    }

    public class Security_Group_Repository : MainRepository<Security_Group>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Security_Group> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Security_Group>();
        }
        public IEnumerable<Security_Group> SearchFor(object param)
        {
            return base.SearchForEntity<Security_Group>(param);
        }
        public Security_Group Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Security_Group_Code = Id };
            return base.GetById<Security_Group>(obj, RelationList);
        }
        public void Add(Security_Group entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Security_Group entity)
        {
            Security_Group oldObj = Get(entity.Security_Group_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Security_Group entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Music_Theme_Repository : MainRepository<Music_Theme>
    {
        public Music_Theme Get(decimal? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Theme_Code = Id };
            return base.GetById<Music_Theme>(obj, RelationList);
        }
        public void Add(Music_Theme entity)
        {
            Music_Theme oldObj = Get(entity.Music_Theme_Code);
            // base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Music_Theme entity)
        {
            Music_Theme oldObj = Get(entity.Music_Theme_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Theme entity)
        {
            base.DeleteEntity(entity);
        }
        public IEnumerable<Music_Theme> GetAll(Type[] RelationList = null)
        {
            return base.GetAll<Music_Theme>(RelationList);
        }
    }
    public class Music_Label_Repository : MainRepository<Music_Label>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Music_Label> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Music_Label>();
        }
        public IEnumerable<Music_Label> SearchFor(object param)
        {
            return base.SearchForEntity<Music_Label>(param);
        }
        public Music_Label Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Label_Code = Id };
            return base.GetById<Music_Label>(obj, RelationList);
        }
        public void Add(Music_Label entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Music_Label entity)
        {
            Music_Label oldObj = Get(entity.Music_Label_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Label entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Title_Repository : MainRepository<Title>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Title> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Title>();
        }
        public IEnumerable<Title> SearchFor(object param)
        {
            return base.SearchForEntity<Title>(param);
        }
        public Title Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Label_Code = Id };
            return base.GetById<Title>(obj, RelationList);
        }
        public void Add(Title entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Title entity)
        {
            Title oldObj = Get(entity.Title_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Title entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Music_Album_Repository : MainRepository<Music_Album>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Music_Album> GetAll(Type[] additionalTypes = null)
        {

            return base.GetAll<Music_Album>(additionalTypes);
        }
        public IEnumerable<Music_Album> SearchFor(object param)
        {
            return base.SearchForEntity<Music_Album>(param);
        }
        public Music_Album Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Album_Code = Id };
            return base.GetById<Music_Album>(obj, RelationList);
        }
        public void Add(Music_Album entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Music_Album entity)
        {
            Music_Album oldObj = Get(entity.Music_Album_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Album entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Music_Album_Talent_Repository : MainRepository<Music_Album_Talent>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Music_Album_Talent> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Music_Album_Talent>(additionalTypes);
        }
        public IEnumerable<Music_Album_Talent> SearchFor(object param)
        {
            return base.SearchForEntity<Music_Album_Talent>(param);
        }
        public Music_Album_Talent Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Album_Talent_Code = Id };
            return base.GetById<Music_Album_Talent>(obj, RelationList);
        }
        public void Add(Music_Album_Talent entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Music_Album_Talent entity)
        {
            Music_Album_Talent oldObj = Get(entity.Music_Album_Talent_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Album_Talent entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Currency_Exchange_Rate_Repository : MainRepository<Currency_Exchange_Rate>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Currency_Exchange_Rate> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Currency_Exchange_Rate>(additionalTypes);
        }
        public IEnumerable<Currency_Exchange_Rate> SearchFor(object param)
        {
            return base.SearchForEntity<Currency_Exchange_Rate>(param);
        }
        public Currency_Exchange_Rate Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Currency_Exchange_Rate_Code = Id };
            return base.GetById<Currency_Exchange_Rate>(obj, RelationList);
        }
        public void Add(Currency_Exchange_Rate entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Currency_Exchange_Rate entity)
        {
            Currency_Exchange_Rate oldObj = Get(entity.Currency_Exchange_Rate_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Currency_Exchange_Rate entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Music_Title_Repository : MainRepository<Music_Title>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Music_Title> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Music_Title>(additionalTypes);
        }
        public IEnumerable<Music_Title> SearchFor(object param)
        {
            return base.SearchForEntity<Music_Title>(param);
        }
        public Music_Title Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Title_Code = Id };
            return base.GetById<Music_Title>(obj, RelationList);
        }
        public void Add(Music_Title entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Music_Title entity)
        {
            Music_Title oldObj = Get(entity.Music_Title_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Title entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Music_Override_Reason_Repository : MainRepository<Music_Override_Reason>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Music_Override_Reason> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Music_Override_Reason>(additionalTypes);
        }
        public IEnumerable<Music_Override_Reason> SearchFor(object param)
        {
            return base.SearchForEntity<Music_Override_Reason>(param);
        }
        public Music_Override_Reason Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Override_Reason_Code = Id };
            return base.GetById<Music_Override_Reason>(obj, RelationList);
        }
        public void Add(Music_Override_Reason entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Music_Override_Reason entity)
        {
            Music_Override_Reason oldObj = Get(entity.Music_Override_Reason_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Override_Reason entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Music_Schedule_Transaction_Repository : MainRepository<Music_Schedule_Transaction>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Music_Schedule_Transaction> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Music_Schedule_Transaction>(additionalTypes);
        }
        public IEnumerable<Music_Schedule_Transaction> SearchFor(object param)
        {
            return base.SearchForEntity<Music_Schedule_Transaction>(param);
        }
        public Music_Schedule_Transaction Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Music_Schedule_Transaction_Code = Id };
            return base.GetById<Music_Schedule_Transaction>(obj, RelationList);
        }
        public void Add(Music_Schedule_Transaction entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Music_Schedule_Transaction entity)
        {
            Music_Schedule_Transaction oldObj = Get(Convert.ToInt32(entity.Music_Schedule_Transaction_Code));
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Music_Schedule_Transaction entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Error_Code_Master_Repository : MainRepository<Error_Code_Master>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Error_Code_Master> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Error_Code_Master>(additionalTypes);
        }
        public IEnumerable<Error_Code_Master> SearchFor(object param)
        {
            return base.SearchForEntity<Error_Code_Master>(param);
        }
        public Error_Code_Master Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Error_Code_Master_Code = Id };
            return base.GetById<Error_Code_Master>(obj, RelationList);
        }
        public void Add(Error_Code_Master entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Error_Code_Master entity)
        {
            Error_Code_Master oldObj = Get(entity.Error_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Error_Code_Master entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Title_Content_Repository : MainRepository<Title_Content>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Title_Content> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Title_Content>(additionalTypes);
        }
        public IEnumerable<Title_Content> SearchFor(object param)
        {
            return base.SearchForEntity<Title_Content>(param);
        }
        public Title_Content Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Title_Content_Code = Id };
            return base.GetById<Title_Content>(obj, RelationList);
        }
        public void Add(Title_Content entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Title_Content entity)
        {
            Title_Content oldObj = Get(entity.Title_Content_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Title_Content entity)
        {
            base.DeleteEntity(entity);
        }
    }
    public class Talent_Role_Repository : MainRepository<Talent_Role>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Talent_Role> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Talent_Role>(additionalTypes);
        }
        public IEnumerable<Talent_Role> SearchFor(object param)
        {
            return base.SearchForEntity<Talent_Role>(param);
        }
        public Talent_Role Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Talent_Role_Code = Id };
            return base.GetById<Talent_Role>(obj, RelationList);
        }
        public void Add(Talent_Role entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Talent_Role entity)
        {
            Talent_Role oldObj = Get(entity.Talent_Role_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Talent_Role entity)
        {
            base.DeleteEntity(entity);
        }
    }
}