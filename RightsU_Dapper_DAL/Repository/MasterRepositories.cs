using Dapper;
using RightsU_Dapper.DAL.Infrastructure;
using RightsU_Dapper.Entity;
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
    public class Talent_Repository : MainRepository<Talent>
    {
        public Talent Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Talent_Code = Id };
            return base.GetTalentById<Talent>(obj, RelationList);
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
            return base.GetTalentById<Language_Group>(obj, RelationList);
        }
        public void Add(Language_Group entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Language_Group entity)
        {
            Language_Group oldObj = Get(entity.Language_Group_Code);
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
            var obj = new { Language_Group_Code = Id };
            return base.GetTalentById<Language>(obj, RelationList);
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
            return base.GetAll<Language>();
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
            return base.GetTalentById<Promoter_Remarks>(obj, RelationList);
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
            return base.GetTalentById<Grade_Master>(obj, RelationList);
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
            var obj = new { Grade_Code = Id };
            return base.GetTalentById<Currency>(obj, RelationList);
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
    public class Genres_Repository : MainRepository<Genres>
    {
        //public Grade_Master_Repository(string conStr) : base(conStr) { }

        public IEnumerable<Genres> GetAll(Type[] additionalTypes = null)
        {
            return base.GetAll<Genres>();
        }
        public IEnumerable<Genres> SearchFor(object param)
        {
            return base.SearchForEntity<Genres>(param);
        }
        public Genres Get(int? Id, Type[] RelationList = null)
        {
            var obj = new { Genres_Code = Id };
            return base.GetTalentById<Genres>(obj, RelationList);
        }
        public void Add(Genres entity)
        {
            //Talent oldObj = Get(entity.Talent_Code);
            //base.UpdateEntity(oldObj, entity);
            base.AddEntity(entity);
        }
        public void Update(Genres entity)
        {
            Genres oldObj = Get(entity.Genres_Code);
            base.UpdateEntity(oldObj, entity);
        }
        public void Delete(Genres entity)
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
            return base.GetTalentById<Cost_Type>(obj, RelationList);
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
            return base.GetTalentById<Document_Type>(obj, RelationList);
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
            return base.GetTalentById<Right_Rule>(obj, RelationList);
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
            return base.GetTalentById<Material_Medium>(obj, RelationList);
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
            return base.GetTalentById<Country>(obj, RelationList);
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
            return base.GetTalentById<Material_Type>(obj, RelationList);
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
            return base.GetTalentById<Category>(obj, RelationList);
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
            return base.GetTalentById<System_Parameter_New>(obj, RelationList);
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
            return base.GetTalentById<Platform_Group>(obj, RelationList);
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
            return base.GetTalentById<Platform>(obj, RelationList);
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
                return base.GetTalentById<Milestone_Nature>(obj, RelationList);
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
            return base.GetTalentById<Program>(obj, RelationList);
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
            return base.GetTalentById<Platform_Group_Details>(obj, RelationList);
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
            return base.GetTalentById<Deal_Type>(obj, RelationList);
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
}
