using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class Talent_Service
    {
        Talent_Repository objTalent_Repository = new Talent_Repository();
        public Talent_Service()
        {
            this.objTalent_Repository = new Talent_Repository();
        }
        public Talent GetTalentByID(int? ID, Type[] RelationList = null)
        {
            return objTalent_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Talent> GetTalentList()
        {
            return objTalent_Repository.GetAll();
        }
        public void AddEntity(Talent obj)
        {
            objTalent_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Talent obj)
        {
            objTalent_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Talent obj)
        {
            objTalent_Repository.Delete(obj);
        }

        public IEnumerable<Talent> SearchFor(object param)
        {
            return objTalent_Repository.SearchFor(param);
        }
        public IEnumerable<Talent> GetList(Type[] additionalTypes = null)
        {
            return objTalent_Repository.GetAll();
        }
        private bool ValidateDuplicate(Talent objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Role_Service
    {
        // private readonly Role_Repository objRole;
        Role_Repository objRole_Repository = new Role_Repository();
        //public Role_Service(string Connection_Str)
        //{
        //    this.objRole = new Role_Repository(Connection_Str);
        //}
        public IEnumerable<Role> SearchFor(object param)
        {
            return objRole_Repository.SearchFor(param);
        }

        public IEnumerable<Role> GetList()
        {
            return objRole_Repository.GetAll();
        }
        public Role GetRoleByID(int? ID, Type[] RelationList = null)
        {
            return objRole_Repository.Get(ID, RelationList);
        }
    }
    public class Language_Group_Service
    {
        Language_Group_Repository objLanguageGroup_Repository = new Language_Group_Repository();
        public Language_Group_Service()
        {
            this.objLanguageGroup_Repository = new Language_Group_Repository();
        }
        public Language_Group GetLanguageGroupByID(int? ID, Type[] RelationList = null)
        {
            return objLanguageGroup_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Language_Group> GetLanguageGroupList()
        {
            return objLanguageGroup_Repository.GetAll();
        }
        public void AddEntity(Language_Group obj)
        {
            objLanguageGroup_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Language_Group obj)
        {
            objLanguageGroup_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Language_Group obj)
        {
            objLanguageGroup_Repository.Delete(obj);
        }

        public IEnumerable<Language_Group> SearchFor(object param)
        {
            return objLanguageGroup_Repository.SearchFor(param);
        }
        public IEnumerable<Language_Group> GetList(Type[] additionalTypes = null)
        {
            return objLanguageGroup_Repository.GetAll(additionalTypes);
        }
        private bool ValidateDuplicate(Language_Group objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Language_Service
    {
        Language_Repository objLanguage_Repository = new Language_Repository();

        //public Language_Service(string Connection_Str)
        //{
        //    this.objLanguage_Repository = new Language_Repository(Connection_Str);
        //}
        public IEnumerable<Language> SearchFor(object param)
        {
            return objLanguage_Repository.SearchFor(param);
        }
        //public IQueryable<Language> SearchFor(Expression<Func<Language, bool>> predicate)
        //{
        //    return objLanguageGroup_Repository.SearchFor(predicate);
        //}

        //public Language GetById(int id)
        //{
        //    return objLanguage_Repository.GetById(id);
        //}
        public IEnumerable<Language> GetList(Type[] additionalTypes = null)
        {
            return objLanguage_Repository.GetAll(additionalTypes);
        }
        public void AddEntity(Language obj)
        {
            objLanguage_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Language obj)
        {
            objLanguage_Repository.Update(obj);
        }

        public void DeleteLanguage(Language obj)
        {
            objLanguage_Repository.Delete(obj);
        }
        //public override bool Validate(Language objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Language objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Language objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        private bool ValidateDuplicate(Language objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Language_Name == objToValidate.Language_Name && s.Language_Code != objToValidate.Language_Code).Count() > 0)
            //{
            //    resultSet = "Language already exists";
            //    return false;
            //}

            resultSet = "";
            return true;
        }

    }
    public class Promoter_Remarks_Service
    {
        Promoter_Remarks_Repository objPromoter_Remarks_Repository = new Promoter_Remarks_Repository();
        public IEnumerable<Promoter_Remarks> GetList(Type[] additionalTypes = null)
        {
            return objPromoter_Remarks_Repository.GetAll();
        }

        public IEnumerable<Promoter_Remarks> SearchFor(object param)
        {
            return objPromoter_Remarks_Repository.SearchFor(param);
        }
        public Promoter_Remarks GetPromoterRemarkByID(int? ID, Type[] RelationList = null)
        {
            return objPromoter_Remarks_Repository.Get(ID, RelationList);
        }
        public void AddEntity(Promoter_Remarks obj)
        {
            objPromoter_Remarks_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Promoter_Remarks obj)
        {
            objPromoter_Remarks_Repository.Update(obj);
        }
        //public bool Save(Promoter_Remarks objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objPromoter_Remarks_Repository, out resultSet);
        //}

        //public bool Update(Promoter_Remarks objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objPromoter_Remarks_Repository, out resultSet);
        //}
        public void DeletePromoter_Remarks(Promoter_Remarks obj)
        {
            objPromoter_Remarks_Repository.Delete(obj);
        }
        //public bool Delete(Promoter_Remarks objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objPromoter_Remarks_Repository, out resultSet);
        //}

        //public override bool Validate(Promoter_Remarks objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Promoter_Remarks objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Promoter_Remarks objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //private bool ValidateDuplicate(Promoter_Remarks objToValidate, out dynamic resultSet)
        //{
        //    if (objToValidate.EntityState != State.Deleted)
        //    {
        //        int duplicateRecordCount = SearchFor(s => s.Promoter_Remark_Desc.ToUpper() == objToValidate.Promoter_Remark_Desc.ToUpper() &&
        //            s.Promoter_Remarks_Code != objToValidate.Promoter_Remarks_Code).Count();

        //        if (duplicateRecordCount > 0)
        //        {
        //            resultSet = "Promoter Remark already exists";
        //            return false;
        //        }
        //    }

        //    resultSet = "";
        //    return true;
        //}
    }
    public class Grade_Master_Service
    {
        private readonly Grade_Master_Repository objRepository;

        //public Grade_Master_Service(string Connection_Str)
        //{
        //    this.objRepository = new Grade_Master_Repository(Connection_Str);
        //}
        Grade_Master_Repository objGrade_Master_Remarks_Repository = new Grade_Master_Repository();
        public IEnumerable<Grade_Master> GetList(Type[] additionalTypes = null)
        {
            return objGrade_Master_Remarks_Repository.GetAll();
        }

        public IEnumerable<Grade_Master> SearchFor(object param)
        {
            return objGrade_Master_Remarks_Repository.SearchFor(param);
        }
        public Grade_Master GetGrade_MasterByID(int? ID, Type[] RelationList = null)
        {
            return objGrade_Master_Remarks_Repository.Get(ID, RelationList);
        }
        public void AddEntity(Grade_Master obj)
        {
            objGrade_Master_Remarks_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Grade_Master obj)
        {
            objGrade_Master_Remarks_Repository.Update(obj);
        }

        public void DeleteGrade_Master(Grade_Master obj)
        {
            objGrade_Master_Remarks_Repository.Delete(obj);
        }
        //public override bool Validate(Grade_Master objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Grade_Master objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Grade_Master objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        private bool ValidateDuplicate(Grade_Master objToValidate, out dynamic resultSet)
        {
            //if (objToValidate.EntityState != State.Deleted)
            //{
            //    int duplicateRecordCount = SearchFor(s => s.Grade_Name.ToUpper() == objToValidate.Grade_Name.ToUpper() &&
            //        s.Grade_Code != objToValidate.Grade_Code).Count();

            //    if (duplicateRecordCount > 0)
            //    {
            //        resultSet = "Grade already exists";
            //        return false;
            //    }
            //}

            resultSet = "";
            return true;
        }
    }
    public class Currency_Service
    {
        Currency_Repository objCurrency_Repository = new Currency_Repository();
        public Currency_Service()
        {
            this.objCurrency_Repository = new Currency_Repository();
        }
        public Currency GetTalentByID(int? ID, Type[] RelationList = null)
        {
            return objCurrency_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Currency> GetTalentList()
        {
            return objCurrency_Repository.GetAll();
        }
        public void AddEntity(Currency obj)
        {
            objCurrency_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Currency obj)
        {
            objCurrency_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Currency obj)
        {
            objCurrency_Repository.Delete(obj);
        }

        public IEnumerable<Currency> SearchFor(object param)
        {
            return objCurrency_Repository.SearchFor(param);
        }
        public IEnumerable<Currency> GetList(Type[] additionalTypes = null)
        {
            return objCurrency_Repository.GetAll();
        }
        private bool ValidateDuplicate(Currency objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Genres_Service
    {
        Genres_Repository objGenres_Repository = new Genres_Repository();
        public Genres_Service()
        {
            this.objGenres_Repository = new Genres_Repository();
        }
        public Genres GetGenresByID(int? ID, Type[] RelationList = null)
        {
            return objGenres_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Genres> GetTalentList()
        {
            return objGenres_Repository.GetAll();
        }
        public void AddEntity(Genres obj)
        {
            objGenres_Repository.Add(obj);
        }
        public void UpdateGenres(Genres obj)
        {
            objGenres_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Genres obj)
        {
            objGenres_Repository.Delete(obj);
        }

        public IEnumerable<Genres> SearchFor(object param)
        {
            return objGenres_Repository.SearchFor(param);
        }
        public IEnumerable<Genres> GetList(Type[] additionalTypes = null)
        {
            return objGenres_Repository.GetAll();
        }
        private bool ValidateDuplicate(Genres objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Cost_Type_Service
    {
        Cost_Type_Repository objCostType_Repository = new Cost_Type_Repository();
        public Cost_Type_Service()
        {
            this.objCostType_Repository = new Cost_Type_Repository();
        }
        public Cost_Type GetGenresByID(int? ID, Type[] RelationList = null)
        {
            return objCostType_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Cost_Type> GetTalentList()
        {
            return objCostType_Repository.GetAll();
        }
        public void AddEntity(Cost_Type obj)
        {
            objCostType_Repository.Add(obj);
        }
        public void UpdateGenres(Cost_Type obj)
        {
            objCostType_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Cost_Type obj)
        {
            objCostType_Repository.Delete(obj);
        }

        public IEnumerable<Cost_Type> SearchFor(object param)
        {
            return objCostType_Repository.SearchFor(param);
        }
        public IEnumerable<Cost_Type> GetList(Type[] additionalTypes = null)
        {
            return objCostType_Repository.GetAll();
        }
        private bool ValidateDuplicate(Cost_Type objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Document_Type_Service
    {
        Document_Type_Repository objDocumentType_Repository = new Document_Type_Repository();
        public Document_Type_Service()
        {
            this.objDocumentType_Repository = new Document_Type_Repository();
        }
        public Document_Type GetGenresByID(int? ID, Type[] RelationList = null)
        {
            return objDocumentType_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Document_Type> GetTalentList()
        {
            return objDocumentType_Repository.GetAll();
        }
        public void AddEntity(Document_Type obj)
        {
            objDocumentType_Repository.Add(obj);
        }
        public void UpdateGenres(Document_Type obj)
        {
            objDocumentType_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Document_Type obj)
        {
            objDocumentType_Repository.Delete(obj);
        }

        public IEnumerable<Document_Type> SearchFor(object param)
        {
            return objDocumentType_Repository.SearchFor(param);
        }
        public IEnumerable<Document_Type> GetList(Type[] additionalTypes = null)
        {
            return objDocumentType_Repository.GetAll();
        }
        private bool ValidateDuplicate(Document_Type objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Right_Rule_Service
    {
        Right_Rule_Repository objRightRule_Repository = new Right_Rule_Repository();

        public Right_Rule_Service()
        {
            this.objRightRule_Repository = new Right_Rule_Repository();
        }
        public Right_Rule GetRightRuleByID(int? ID, Type[] RelationList = null)
        {
            return objRightRule_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Right_Rule> GetTalentList()
        {
            return objRightRule_Repository.GetAll();
        }
        public void AddEntity(Right_Rule obj)
        {
            objRightRule_Repository.Add(obj);
        }
        public void UpdateGenres(Right_Rule obj)
        {
            objRightRule_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Right_Rule obj)
        {
            objRightRule_Repository.Delete(obj);
        }

        public IEnumerable<Right_Rule> SearchFor(object param)
        {
            return objRightRule_Repository.SearchFor(param);
        }
        public IEnumerable<Right_Rule> GetList(Type[] additionalTypes = null)
        {
            return objRightRule_Repository.GetAll();
        }


        //private readonly Right_Rule_Repository objRepository;

        //public Right_Rule_Service(string Connection_Str)
        //{
        //    this.objRepository = new Right_Rule_Repository(Connection_Str);
        //}
        //public IQueryable<Right_Rule> SearchFor(Expression<Func<Right_Rule, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Right_Rule GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}

        //public bool Save(Right_Rule objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}
        //public bool Update(Right_Rule objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objRepository, out resultSet);
        //}

        //public bool Delete(Right_Rule objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objRepository, out resultSet);
        //}

        //public override bool Validate(Right_Rule objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Right_Rule objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Right_Rule objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}
        private bool ValidateDuplicate(Right_Rule objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Right_Rule_Name == objToValidate.Right_Rule_Name && s.Right_Rule_Code != objToValidate.Right_Rule_Code).Count() > 0)
            //{
            //    resultSet = "Right Rule already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Country_Service
    {
        Country_Repository objCountry_Repository = new Country_Repository();

        public Country_Service()
        {
            this.objCountry_Repository = new Country_Repository();
        }
        public Country GetRightRuleByID(int? ID, Type[] RelationList = null)
        {
            return objCountry_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Country> GetTalentList()
        {
            return objCountry_Repository.GetAll();
        }
        public void AddEntity(Country obj)
        {
            objCountry_Repository.Add(obj);
        }
        public void UpdateGenres(Country obj)
        {
            objCountry_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Country obj)
        {
            objCountry_Repository.Delete(obj);
        }

        public IEnumerable<Country> SearchFor(object param)
        {
            return objCountry_Repository.SearchFor(param);
        }
        public IEnumerable<Country> GetList(Type[] additionalTypes = null)
        {
            return objCountry_Repository.GetAll();
        }

        //    //public override bool Validate(Country objToValidate, out dynamic resultSet)
        //    //{
        //    //    return ValidateDuplicate(objToValidate, out resultSet);
        //    //}

        //    //public override bool ValidateUpdate(Country objToValidate, out dynamic resultSet)
        //    //{
        //    //    return ValidateDuplicate(objToValidate, out resultSet);
        //    //}

        //    //public override bool ValidateDelete(Country objToValidate, out dynamic resultSet)
        //    //{
        //    //    return ValidateDuplicate(objToValidate, out resultSet);
        //    //}
        //    private bool ValidateDuplicate(Country objToValidate, out dynamic resultSet)
        //    {
        //        //if (SearchFor(s => s.Country_Name.Trim() == objToValidate.Country_Name.Trim() && s.Country_Code != objToValidate.Country_Code).Count() > 0)
        //        //{
        //        //    resultSet = "Country already exists";
        //        //    return false;
        //        //}

        //        resultSet = "";
        //        return true;
        //    }

    }
    public class Material_Medium_Service
    {
        Material_Medium_Repository objMaterial_Medium_Repository = new Material_Medium_Repository();

        public Material_Medium_Service()
        {
            this.objMaterial_Medium_Repository = new Material_Medium_Repository();
        }
        public Material_Medium GetRightRuleByID(int? ID, Type[] RelationList = null)
        {
            return objMaterial_Medium_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Material_Medium> GetTalentList()
        {
            return objMaterial_Medium_Repository.GetAll();
        }
        public void AddEntity(Material_Medium obj)
        {
            objMaterial_Medium_Repository.Add(obj);
        }
        public void UpdateGenres(Material_Medium obj)
        {
            objMaterial_Medium_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Material_Medium obj)
        {
            objMaterial_Medium_Repository.Delete(obj);
        }

        public IEnumerable<Material_Medium> SearchFor(object param)
        {
            return objMaterial_Medium_Repository.SearchFor(param);
        }
        public IEnumerable<Material_Medium> GetList(Type[] additionalTypes = null)
        {
            return objMaterial_Medium_Repository.GetAll();
        }

        //private readonly Material_Medium_Repository objRepository;

        //public Material_Medium_Service(string Connection_Str)
        //{
        //    this.objRepository = new Material_Medium_Repository(Connection_Str);
        //}
        //public IQueryable<Material_Medium> SearchFor(Expression<Func<Material_Medium, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Material_Medium GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}
        //public bool Save(Material_Medium objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}

        //public bool Update(Material_Medium objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objRepository, out resultSet);
        //}

        //public bool Delete(Material_Medium objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objRepository, out resultSet);
        //}

        //public override bool Validate(Material_Medium objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Material_Medium objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Material_Medium objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        private bool ValidateDuplicate(Material_Medium objToValidate, out dynamic resultSet)
        {
            //if (objToValidate.EntityState != State.Deleted)
            //{
            //    int duplicateRecordCount = SearchFor(s => s.Material_Medium_Name.ToUpper() == objToValidate.Material_Medium_Name.ToUpper() &&
            //        s.Material_Medium_Code != objToValidate.Material_Medium_Code).Count();

            //    if (duplicateRecordCount > 0)
            //    {
            //        resultSet = "Material Medium already exists";
            //        return false;
            //    }
            //}

            resultSet = "";
            return true;
        }
    }
    public class Material_Type_Service
    {
        Material_Type_Repository objMaterial_Type_Repository = new Material_Type_Repository();

        public Material_Type_Service()
        {
            this.objMaterial_Type_Repository = new Material_Type_Repository();
        }
        public Material_Type GetMaterial_TypeByID(int? ID, Type[] RelationList = null)
        {
            return objMaterial_Type_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Material_Type> GetTalentList()
        {
            return objMaterial_Type_Repository.GetAll();
        }
        public void AddEntity(Material_Type obj)
        {
            objMaterial_Type_Repository.Add(obj);
        }
        public void UpdateGenres(Material_Type obj)
        {
            objMaterial_Type_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Material_Type obj)
        {
            objMaterial_Type_Repository.Delete(obj);
        }

        public IEnumerable<Material_Type> SearchFor(object param)
        {
            return objMaterial_Type_Repository.SearchFor(param);
        }
        public IEnumerable<Material_Type> GetList(Type[] additionalTypes = null)
        {
            return objMaterial_Type_Repository.GetAll();
        }
        //private readonly Material_Type_Repository objRepository;

        //public Material_Type_Service(string Connection_Str)
        //{
        //    this.objRepository = new Material_Type_Repository(Connection_Str);
        //}
        //public IQueryable<Material_Type> SearchFor(Expression<Func<Material_Type, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Material_Type GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}

        //public bool Save(Material_Type objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}

        //public bool Update(Material_Type objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objRepository, out resultSet);
        //}

        //public bool Delete(Material_Type objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objRepository, out resultSet);
        //}

        //public override bool Validate(Material_Type objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Material_Type objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Material_Type objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        private bool ValidateDuplicate(Material_Type objToValidate, out dynamic resultSet)
        {
            //if (objToValidate.EntityState != State.Deleted)
            //{
            //    int duplicateRecordCount = SearchFor(s => s.Material_Type_Name.ToUpper() == objToValidate.Material_Type_Name.ToUpper() &&
            //        s.Material_Type_Code != objToValidate.Material_Type_Code).Count();

            //    if (duplicateRecordCount > 0)
            //    {
            //        resultSet = "Material Type already exists";
            //        return false;
            //    }
            //}

            resultSet = "";
            return true;
        }
    }
    public class Category_Service
    {
        Category_Repository objCategory_Repository = new Category_Repository();

        public Category_Service()
        {
            this.objCategory_Repository = new Category_Repository();
        }
        public Category GetCategoryByID(int? ID, Type[] RelationList = null)
        {
            return objCategory_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Category> GetTalentList()
        {
            return objCategory_Repository.GetAll();
        }
        public void AddEntity(Category obj)
        {
            objCategory_Repository.Add(obj);
        }
        public void UpdateCategory(Category obj)
        {
            objCategory_Repository.Update(obj);
        }
        public void DeleteCategory(Category obj)
        {
            objCategory_Repository.Delete(obj);
        }

        public IEnumerable<Category> SearchFor(object param)
        {
            return objCategory_Repository.SearchFor(param);
        }
        public IEnumerable<Category> GetList(Type[] additionalTypes = null)
        {
            return objCategory_Repository.GetAll();
        }
        //private readonly Category_Repository objRepository;

        //public Category_Service(string Connection_Str)
        //{
        //    this.objRepository = new Category_Repository(Connection_Str);
        //}
        //public IQueryable<Category> SearchFor(Expression<Func<Category, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Category GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}

        //public bool Save(Category objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}

        //public bool Update(Category objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objRepository, out resultSet);
        //}

        //public bool Delete(Category objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objRepository, out resultSet);
        //}

        //public override bool Validate(Category objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Category objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Category objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}
        //private bool ValidateDuplicate(Category objToValidate, out dynamic resultSet)
        //{
        //    if (SearchFor(s => s.Category_Name == objToValidate.Category_Name && s.Category_Code != objToValidate.Category_Code).Count() > 0)
        //    {
        //        resultSet = "Category already exists";
        //        return false;
        //    }

        //    resultSet = "";
        //    return true;
        //}
    }
    public class System_Parameter_New_Service
    {
        System_Parameter_New_Repository objSystem_Parameter_New_Repository = new System_Parameter_New_Repository();

        public System_Parameter_New_Service()
        {
            this.objSystem_Parameter_New_Repository = new System_Parameter_New_Repository();
        }
        public System_Parameter_New GetCategoryByID(int? ID, Type[] RelationList = null)
        {
            return objSystem_Parameter_New_Repository.Get(ID, RelationList);
        }
        public IEnumerable<System_Parameter_New> GetTalentList()
        {
            return objSystem_Parameter_New_Repository.GetAll();
        }
        public void AddEntity(System_Parameter_New obj)
        {
            objSystem_Parameter_New_Repository.Add(obj);
        }
        public void UpdateCategory(System_Parameter_New obj)
        {
            objSystem_Parameter_New_Repository.Update(obj);
        }
        public void DeleteCategory(System_Parameter_New obj)
        {
            objSystem_Parameter_New_Repository.Delete(obj);
        }

        public IEnumerable<System_Parameter_New> SearchFor(object param)
        {
            return objSystem_Parameter_New_Repository.SearchFor(param);
        }
        public IEnumerable<System_Parameter_New> GetList(Type[] additionalTypes = null)
        {
            return objSystem_Parameter_New_Repository.GetAll();
        }
        //    private readonly System_Parameter_New_Repository objRepository;

        //    public System_Parameter_New_Service(string Connection_Str)
        //    {
        //        this.objRepository = new System_Parameter_New_Repository(Connection_Str);
        //    }
        //    public IQueryable<System_Parameter_New> SearchFor(Expression<Func<System_Parameter_New, bool>> predicate)
        //    {
        //        return objRepository.SearchFor(predicate);
        //    }

        //    public System_Parameter_New GetById(int id)
        //    {
        //        return objRepository.GetById(id);
        //    }

        //    public bool Save(System_Parameter_New objToSave, out dynamic resultSet)
        //    {
        //        return base.Save(objToSave, objRepository, out resultSet);
        //    }

        //    public bool Update(System_Parameter_New objToUpdate, out dynamic resultSet)
        //    {
        //        return base.Update(objToUpdate, objRepository, out resultSet);
        //    }

        //    public bool Delete(System_Parameter_New objToDelete, out dynamic resultSet)
        //    {
        //        return base.Delete(objToDelete, objRepository, out resultSet);
        //    }

        //    public override bool Validate(System_Parameter_New objToValidate, out dynamic resultSet)
        //    {
        //        resultSet = "";
        //        return true;
        //    }

        //    public override bool ValidateUpdate(System_Parameter_New objToValidate, out dynamic resultSet)
        //    {
        //        resultSet = "";
        //        return true;
        //    }

        //    public override bool ValidateDelete(System_Parameter_New objToValidate, out dynamic resultSet)
        //    {
        //        resultSet = "";
        //        return true;
        //    }
    }
    public class Platform_Group_Service
    {
        Platform_Group_Repository objPlatform_Group_Repository = new Platform_Group_Repository();

        public Platform_Group_Service()
        {
            this.objPlatform_Group_Repository = new Platform_Group_Repository();
        }
        public Platform_Group GetPlatformGroupByID(int? ID, Type[] RelationList = null)
        {
            return objPlatform_Group_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Platform_Group> GetTalentList()
        {
            return objPlatform_Group_Repository.GetAll();
        }
        public void AddEntity(Platform_Group obj)
        {
            objPlatform_Group_Repository.Add(obj);
        }
        public void UpdateCategory(Platform_Group obj)
        {
            objPlatform_Group_Repository.Update(obj);
        }
        public void DeleteCategory(Platform_Group obj)
        {
            objPlatform_Group_Repository.Delete(obj);
        }

        public IEnumerable<Platform_Group> SearchFor(object param)
        {
            return objPlatform_Group_Repository.SearchFor(param);
        }
        public IEnumerable<Platform_Group> GetList(Type[] additionalTypes = null)
        {
            return objPlatform_Group_Repository.GetAll(additionalTypes);
        }
        //private readonly Platform_Group_Repository objRepository;

        //public Platform_Group_Service(string Connection_Str)
        //{
        //    this.objRepository = new Platform_Group_Repository(Connection_Str);
        //}
        //public IQueryable<Platform_Group> SearchFor(Expression<Func<Platform_Group, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Platform_Group GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}

        //public bool Save(Platform_Group objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}

        //public override bool Validate(Platform_Group objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Platform_Group objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Platform_Group objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //private bool ValidateDuplicate(Platform_Group objToValidate, out dynamic resultSet)
        //{
        //    if (SearchFor(s => s.Platform_Group_Name.ToUpper() == objToValidate.Platform_Group_Name.ToUpper().Trim() && s.Platform_Group_Code != objToValidate.Platform_Group_Code).Count() > 0)
        //    {
        //        resultSet = "Platform group already exists";
        //        return false;
        //    }

        //    resultSet = "";
        //    return true;
        //}
    }
    public class Platform_Service
    {
        Platform_Repository objPlatform_Repository = new Platform_Repository();
        public IEnumerable<Platform> SearchFor(object param)
        {
            return objPlatform_Repository.SearchFor(param);
        }
        public IEnumerable<Platform> GetList(Type[] additionalTypes = null)
        {
            return objPlatform_Repository.GetAll();
        }
        public Platform GetPlatformByID(int? ID, Type[] RelationList = null)
        {
            return objPlatform_Repository.Get(ID, RelationList);
        }
        //private readonly Platform_Repository objPlatform;

        //public Platform_Service(string Connection_Str)
        //{
        //    this.objPlatform = new Platform_Repository(Connection_Str);
        //}
        //public IQueryable<Platform> SearchFor(Expression<Func<Platform, bool>> predicate)
        //{
        //    return objPlatform.SearchFor(predicate);
        //}

        //public Platform GetById(int id)
        //{
        //    return objPlatform.GetById(id);
        //}
    }
    public class Milestone_Nature_Service
    {
        Milestone_Nature_Repository objMilestone_Nature_Repository = new Milestone_Nature_Repository();

        public Milestone_Nature_Service()
        {
            this.objMilestone_Nature_Repository = new Milestone_Nature_Repository();
        }
        public Milestone_Nature GetMilestone_NatureGroupByID(int? ID, Type[] RelationList = null)
        {
            return objMilestone_Nature_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Milestone_Nature> GetTalentList()
        {
            return objMilestone_Nature_Repository.GetAll();
        }
        public void AddEntity(Milestone_Nature obj)
        {
            objMilestone_Nature_Repository.Add(obj);
        }
        public void UpdateCategory(Milestone_Nature obj)
        {
            objMilestone_Nature_Repository.Update(obj);
        }
        public void DeleteCategory(Milestone_Nature obj)
        {
            objMilestone_Nature_Repository.Delete(obj);
        }

        public IEnumerable<Milestone_Nature> SearchFor(object param)
        {
            return objMilestone_Nature_Repository.SearchFor(param);
        }
        public IEnumerable<Milestone_Nature> GetList(Type[] additionalTypes = null)
        {
            return objMilestone_Nature_Repository.GetAll();
        }
        //    private readonly Milestone_Nature_Repository objRepository;

        //    public Milestone_Nature_Service(string Connection_Str)
        //    {
        //        this.objRepository = new Milestone_Nature_Repository(Connection_Str);
        //    }
        //    public IQueryable<Milestone_Nature> SearchFor(Expression<Func<Milestone_Nature, bool>> predicate)
        //    {
        //        return objRepository.SearchFor(predicate);
        //    }

        //    public Milestone_Nature GetById(int id)
        //    {
        //        return objRepository.GetById(id);
        //    }

        //    public bool Save(Milestone_Nature objToSave, out dynamic resultSet)
        //    {
        //        return base.Save(objToSave, objRepository, out resultSet);
        //    }

        //    public bool Update(Milestone_Nature objToUpdate, out dynamic resultSet)
        //    {
        //        return base.Update(objToUpdate, objRepository, out resultSet);
        //    }

        //    public bool Delete(Milestone_Nature objToDelete, out dynamic resultSet)
        //    {
        //        return base.Delete(objToDelete, objRepository, out resultSet);
        //    }

        //    public override bool Validate(Milestone_Nature objToValidate, out dynamic resultSet)
        //    {
        //        return ValidateDuplicate(objToValidate, out resultSet);
        //    }

        //    public override bool ValidateUpdate(Milestone_Nature objToValidate, out dynamic resultSet)
        //    {
        //        return ValidateDuplicate(objToValidate, out resultSet);

        //    }

        //    public override bool ValidateDelete(Milestone_Nature objToValidate, out dynamic resultSet)
        //    {
        //        resultSet = "";
        //        return true;
        //    }

        //    private bool ValidateDuplicate(Milestone_Nature objToValidate, out dynamic resultSet)
        //    {
        //        if (SearchFor(s => s.Milestone_Nature_Name == objToValidate.Milestone_Nature_Name && s.Milestone_Nature_Code != objToValidate.Milestone_Nature_Code).Count() > 0)
        //        {
        //            resultSet = "Milestone Nature already exists";
        //            return false;
        //        }

        //        resultSet = "";
        //        return true;
        //    }
        //}
    }
    public class Platform_Group_Details_Service
    {
        Platform_Group_Details_Repository objPlatform_Group_Details_Repository = new Platform_Group_Details_Repository();

        public Platform_Group_Details_Service()
        {
            this.objPlatform_Group_Details_Repository = new Platform_Group_Details_Repository();
        }
        public Platform_Group_Details GetPlatform_Group_DetailsGroupByID(int? ID, Type[] RelationList = null)
        {
            return objPlatform_Group_Details_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Platform_Group_Details> GetTalentList()
        {
            return objPlatform_Group_Details_Repository.GetAll();
        }
        public void AddEntity(Platform_Group_Details obj)
        {
            objPlatform_Group_Details_Repository.Add(obj);
        }
        public void UpdateCategory(Platform_Group_Details obj)
        {
            objPlatform_Group_Details_Repository.Update(obj);
        }
        public void DeleteCategory(Platform_Group_Details obj)
        {
            objPlatform_Group_Details_Repository.Delete(obj);
        }

        public IEnumerable<Platform_Group_Details> SearchFor(object param)
        {
            return objPlatform_Group_Details_Repository.SearchFor(param);
        }
        public IEnumerable<Platform_Group_Details> GetList(Type[] additionalTypes = null)
        {
            return objPlatform_Group_Details_Repository.GetAll(additionalTypes);
        }
        //private readonly Platform_Group_Details_Repository objRepository;

        //public Platform_Group_Details_Service(string Connection_Str)
        //{
        //    this.objRepository = new Platform_Group_Details_Repository(Connection_Str);
        //}
        //public IQueryable<Platform_Group_Details> SearchFor(Expression<Func<Platform_Group_Details, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Platform_Group_Details GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}

        //public bool Save(Platform_Group_Details objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}

        //public override bool Validate(Platform_Group_Details objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //public override bool ValidateUpdate(Platform_Group_Details objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //public override bool ValidateDelete(Platform_Group_Details objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}
    }
    public class Program_Service
    {
        Program_Repository objProgram_Repository = new Program_Repository();

        public Program_Service()
        {
            this.objProgram_Repository = new Program_Repository();
        }
        public Program GetProgramGroupByID(int? ID, Type[] RelationList = null)
        {
            return objProgram_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Program> GetTalentList()
        {
            return objProgram_Repository.GetAll();
        }
        public void AddEntity(Program obj)
        {
            objProgram_Repository.Add(obj);
        }
        public void UpdateCategory(Program obj)
        {
            objProgram_Repository.Update(obj);
        }
        public void DeleteCategory(Program obj)
        {
            objProgram_Repository.Delete(obj);
        }

        public IEnumerable<Program> SearchFor(object param)
        {
            return objProgram_Repository.SearchFor(param);
        }
        public IEnumerable<Program> GetList(Type[] additionalTypes = null)
        {
            return objProgram_Repository.GetAll(additionalTypes);
        }
    }
    public class Deal_Type_Service
    {
        Deal_Type_Repository objDeal_Type_Repository = new Deal_Type_Repository();

        public Deal_Type_Service()
        {
            this.objDeal_Type_Repository = new Deal_Type_Repository();
        }
        public Deal_Type GetDeal_TypeByID(int? ID, Type[] RelationList = null)
        {
            return objDeal_Type_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Deal_Type> GetTalentList()
        {
            return objDeal_Type_Repository.GetAll();
        }
        public void AddEntity(Deal_Type obj)
        {
            objDeal_Type_Repository.Add(obj);
        }
        public void UpdateCategory(Deal_Type obj)
        {
            objDeal_Type_Repository.Update(obj);
        }
        public void DeleteCategory(Deal_Type obj)
        {
            objDeal_Type_Repository.Delete(obj);
        }

        public IEnumerable<Deal_Type> SearchFor(object param)
        {
            return objDeal_Type_Repository.SearchFor(param);
        }
        public IEnumerable<Deal_Type> GetList(Type[] additionalTypes = null)
        {
            return objDeal_Type_Repository.GetAll(additionalTypes);
        }
    }
    public class Party_Category_Service
    {
        Party_Category_Repository objParty_Category_Repository = new Party_Category_Repository();

        public Party_Category_Service()
        {
            this.objParty_Category_Repository = new Party_Category_Repository();
        }
        public Party_Category GetParty_CategoryByID(int? ID, Type[] RelationList = null)
        {
            return objParty_Category_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Party_Category> GetTalentList()
        {
            return objParty_Category_Repository.GetAll();
        }
        public void AddEntity(Party_Category obj)
        {
            objParty_Category_Repository.Add(obj);
        }
        public void UpdateCategory(Party_Category obj)
        {
            objParty_Category_Repository.Update(obj);
        }
        public void DeleteCategory(Party_Category obj)
        {
            objParty_Category_Repository.Delete(obj);
        }

        public IEnumerable<Party_Category> SearchFor(object param)
        {
            return objParty_Category_Repository.SearchFor(param);
        }
        public IEnumerable<Party_Category> GetList(Type[] additionalTypes = null)
        {
            return objParty_Category_Repository.GetAll(additionalTypes);
        }
    }
    public class BV_HouseId_Data_Service
    {
        BV_HouseId_Data_Repository objBV_HouseId_Data_Repository = new BV_HouseId_Data_Repository();

        public BV_HouseId_Data_Service()
        {
            this.objBV_HouseId_Data_Repository = new BV_HouseId_Data_Repository();
        }
        public BV_HouseId_Data GetBV_HouseId_DataByID(int? ID, Type[] RelationList = null)
        {
            return objBV_HouseId_Data_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BV_HouseId_Data> GetTalentList()
        {
            return objBV_HouseId_Data_Repository.GetAll();
        }
        public void AddEntity(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Add(obj);
        }
        public void UpdateBV_HouseId_Data(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Update(obj);
        }
        public void DeleteCategory(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Delete(obj);
        }

        public IEnumerable<BV_HouseId_Data> SearchFor(object param)
        {
            return objBV_HouseId_Data_Repository.SearchFor(param);
        }
        public IEnumerable<BV_HouseId_Data> GetList(Type[] additionalTypes = null)
        {
            return objBV_HouseId_Data_Repository.GetAll(additionalTypes);
        }
        //private readonly BV_HouseId_Data_Repository objAD;

        //public BV_HouseId_Data_Service(string Connection_Str)
        //{
        //    this.objAD = new BV_HouseId_Data_Repository(Connection_Str);
        //}
        //public IQueryable<BV_HouseId_Data> SearchFor(Expression<Func<BV_HouseId_Data, bool>> predicate)
        //{
        //    return objAD.SearchFor(predicate);
        //}

        //public BV_HouseId_Data GetById(int id)
        //{
        //    return objAD.GetById(id);
        //}

        //public void Save(BV_HouseId_Data objD)
        //{
        //    objAD.Update(objD);
        //}

    }
    public class Acq_Deal_Movie_Service 
    {
        Acq_Deal_Movie_Repository objAcq_Deal_Movie_Repository = new Acq_Deal_Movie_Repository();

        public Acq_Deal_Movie_Service()
        {
            this.objAcq_Deal_Movie_Repository = new Acq_Deal_Movie_Repository();
        }
        public Acq_Deal_Movie GetAcq_Deal_MovieByID(int? ID, Type[] RelationList = null)
        {
            return objAcq_Deal_Movie_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Acq_Deal_Movie> GetTalentList()
        {
            return objAcq_Deal_Movie_Repository.GetAll();
        }
        public void AddEntity(Acq_Deal_Movie obj)
        {
            objAcq_Deal_Movie_Repository.Add(obj);
        }
        public void UpdateAcq_Deal_Movie(Acq_Deal_Movie obj)
        {
            objAcq_Deal_Movie_Repository.Update(obj);
        }
        public void DeleteCategory(Acq_Deal_Movie obj)
        {
            objAcq_Deal_Movie_Repository.Delete(obj);
        }

        public IEnumerable<Acq_Deal_Movie> SearchFor(object param)
        {
            return objAcq_Deal_Movie_Repository.SearchFor(param);
        }
        public IEnumerable<Acq_Deal_Movie> GetList(Type[] additionalTypes = null)
        {
            return objAcq_Deal_Movie_Repository.GetAll(additionalTypes);
        }
        //private readonly Acq_Deal_Movie_Repository objADMR;
        ////public Acq_Deal_Movie_Service()
        ////{
        ////    this.objADMR = new Acq_Deal_Movie_Repository(DBConnection.Connection_Str);
        ////}
        //public Acq_Deal_Movie_Service(string Connection_Str)
        //{
        //    this.objADMR = new Acq_Deal_Movie_Repository(Connection_Str);
        //}
        //public IQueryable<Acq_Deal_Movie> SearchFor(Expression<Func<Acq_Deal_Movie, bool>> predicate)
        //{
        //    return objADMR.SearchFor(predicate);
        //}

        //public Acq_Deal_Movie GetById(int id)
        //{
        //    return objADMR.GetById(id);
        //}


        //public override bool Validate(Acq_Deal_Movie objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //public override bool ValidateUpdate(Acq_Deal_Movie objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //public override bool ValidateDelete(Acq_Deal_Movie objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}
    }
    public class Title_Content_Mapping_Service 
    {
        Title_Content_Mapping_Repository objTitle_Content_Mapping_Repository = new Title_Content_Mapping_Repository();

        public Title_Content_Mapping_Service()
        {
            this.objTitle_Content_Mapping_Repository = new Title_Content_Mapping_Repository();
        }
        public Title_Content_Mapping GetTitle_Content_MappingByID(int? ID, Type[] RelationList = null)
        {
            return objTitle_Content_Mapping_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Title_Content_Mapping> GetTalentList()
        {
            return objTitle_Content_Mapping_Repository.GetAll();
        }
        public void AddEntity(Title_Content_Mapping obj)
        {
            objTitle_Content_Mapping_Repository.Add(obj);
        }
        public void UpdateTitle_Content_Mapping_Movie(Title_Content_Mapping obj)
        {
            objTitle_Content_Mapping_Repository.Update(obj);
        }
        public void DeleteCategory(Title_Content_Mapping obj)
        {
            objTitle_Content_Mapping_Repository.Delete(obj);
        }

        public IEnumerable<Title_Content_Mapping> SearchFor(object param)
        {
            return objTitle_Content_Mapping_Repository.SearchFor(param);
        }
        public IEnumerable<Title_Content_Mapping> GetList(Type[] additionalTypes = null)
        {
            return objTitle_Content_Mapping_Repository.GetAll(additionalTypes);
        }
        //private readonly Title_Content_Mapping_Repository objRepository;
        ////public Title_Content_Mapping_Service()
        ////{
        ////    this.objRepository = new Title_Content_Mapping_Repository(DBConnection.Connection_Str);
        ////}
        //public Title_Content_Mapping_Service(string Connection_Str)
        //{
        //    this.objRepository = new Title_Content_Mapping_Repository(Connection_Str);
        //}
        //public IQueryable<Title_Content_Mapping> SearchFor(Expression<Func<Title_Content_Mapping, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Title_Content_Mapping GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}

        //public bool Save(Title_Content_Mapping objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}

        //public bool Update(Title_Content_Mapping objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objRepository, out resultSet);
        //}

        //public bool Delete(Title_Content_Mapping objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objRepository, out resultSet);
        //}

        //public override bool Validate(Title_Content_Mapping objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //public override bool ValidateUpdate(Title_Content_Mapping objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //public override bool ValidateDelete(Title_Content_Mapping objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}
    }
    public class Email_Config_Detail_Service
    {
        Email_Config_Detail_Repository objEmail_Config_Detail_Repository = new Email_Config_Detail_Repository();

        public Email_Config_Detail_Service()
        {
            this.objEmail_Config_Detail_Repository = new Email_Config_Detail_Repository();
        }
        public Email_Config_Detail GetTitle_Content_MappingByID(int? ID, Type[] RelationList = null)
        {
            return objEmail_Config_Detail_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Email_Config_Detail> GetTalentList()
        {
            return objEmail_Config_Detail_Repository.GetAll();
        }
        public void AddEntity(Email_Config_Detail obj)
        {
            objEmail_Config_Detail_Repository.Add(obj);
        }
        public void UpdateEmail_Config_Detail_Movie(Email_Config_Detail obj)
        {
            objEmail_Config_Detail_Repository.Update(obj);
        }
        public void DeleteCategory(Email_Config_Detail obj)
        {
            objEmail_Config_Detail_Repository.Delete(obj);
        }

        public IEnumerable<Email_Config_Detail> SearchFor(object param)
        {
            return objEmail_Config_Detail_Repository.SearchFor(param);
        }
        public IEnumerable<Email_Config_Detail> GetList(Type[] additionalTypes = null)
        {
            return objEmail_Config_Detail_Repository.GetAll(additionalTypes);
        }
    }
    public class Email_Config_Service
    {
        Email_Config_Repository objEmail_Config_Repository = new Email_Config_Repository();

        public Email_Config_Service()
        {
            this.objEmail_Config_Repository = new Email_Config_Repository();
        }
        public Email_Config GetEmail_ConfigByID(int? ID, Type[] RelationList = null)
        {
            return objEmail_Config_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Email_Config> GetTalentList()
        {
            return objEmail_Config_Repository.GetAll();
        }
        public void AddEntity(Email_Config obj)
        {
            objEmail_Config_Repository.Add(obj);
        }
        public void UpdateTitle_Content_Mapping_Movie(Email_Config obj)
        {
            objEmail_Config_Repository.Update(obj);
        }
        public void DeleteCategory(Email_Config obj)
        {
            objEmail_Config_Repository.Delete(obj);
        }

        public IEnumerable<Email_Config> SearchFor(object param)
        {
            return objEmail_Config_Repository.SearchFor(param);
        }
        public IEnumerable<Email_Config> GetList(Type[] additionalTypes = null)
        {
            return objEmail_Config_Repository.GetAll(additionalTypes);
        }
    }
    public class Business_Unit_Service
    {
        Business_Unit_Repository objBusiness_Unit_Repository = new Business_Unit_Repository();

        public Business_Unit_Service()
        {
            this.objBusiness_Unit_Repository = new Business_Unit_Repository();
        }
        public Business_Unit GetBusiness_UnitByID(int? ID, Type[] RelationList = null)
        {
            return objBusiness_Unit_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Business_Unit> GetTalentList()
        {
            return objBusiness_Unit_Repository.GetAll();
        }
        public void AddEntity(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Add(obj);
        }
        public void UpdateTitle_Content_Mapping_Movie(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Update(obj);
        }
        public void DeleteCategory(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Delete(obj);
        }

        public IEnumerable<Business_Unit> SearchFor(object param)
        {
            return objBusiness_Unit_Repository.SearchFor(param);
        }
        public IEnumerable<Business_Unit> GetList(Type[] additionalTypes = null)
        {
            return objBusiness_Unit_Repository.GetAll(additionalTypes);
        }
    }
    public class Channel_Service
    {
        Channel_Repository objChannel_Repository = new Channel_Repository();

        public Channel_Service()
        {
            this.objChannel_Repository = new Channel_Repository();
        }
        public Channel GetChannelByID(int? ID, Type[] RelationList = null)
        {
            return objChannel_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Channel> GetTalentList()
        {
            return objChannel_Repository.GetAll();
        }
        public void AddEntity(Channel obj)
        {
            objChannel_Repository.Add(obj);
        }
        public void UpdateChannel(Channel obj)
        {
            objChannel_Repository.Update(obj);
        }
        public void DeleteCategory(Channel obj)
        {
            objChannel_Repository.Delete(obj);
        }

        public IEnumerable<Channel> SearchFor(object param)
        {
            return objChannel_Repository.SearchFor(param);
        }
        public IEnumerable<Channel> GetList(Type[] additionalTypes = null)
        {
            return objChannel_Repository.GetAll(additionalTypes);
        }
    }
    public class User_Service
    {
        User_Repository objUser_Repository = new User_Repository();

        public User_Service()
        {
            this.objUser_Repository = new User_Repository();
        }
        public User GetUserByID(int? ID, Type[] RelationList = null)
        {
            return objUser_Repository.Get(ID, RelationList);
        }
        public IEnumerable<User> GetTalentList()
        {
            return objUser_Repository.GetAll();
        }
        public void AddEntity(User obj)
        {
            objUser_Repository.Add(obj);
        }
        public void UpdateChannel(User obj)
        {
            objUser_Repository.Update(obj);
        }
        public void DeleteCategory(User obj)
        {
            objUser_Repository.Delete(obj);
        }

        public IEnumerable<User> SearchFor(object param)
        {
            return objUser_Repository.SearchFor(param);
        }
        public IEnumerable<User> GetList(Type[] additionalTypes = null)
        {
            return objUser_Repository.GetAll(additionalTypes);
        }
    }
    public class Users_Business_Unit_Service
    {
        Users_Business_Unit_Repository objUsers_Business_Unit_Repository = new Users_Business_Unit_Repository();

        public Users_Business_Unit_Service()
        {
            this.objUsers_Business_Unit_Repository = new Users_Business_Unit_Repository();
        }
        public Users_Business_Unit GetUserByID(int? ID, Type[] RelationList = null)
        {
            return objUsers_Business_Unit_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Users_Business_Unit> GetTalentList()
        {
            return objUsers_Business_Unit_Repository.GetAll();
        }
        public void AddEntity(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Add(obj);
        }
        public void UpdateChannel(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Update(obj);
        }
        public void DeleteCategory(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Delete(obj);
        }

        public IEnumerable<Users_Business_Unit> SearchFor(object param)
        {
            return objUsers_Business_Unit_Repository.SearchFor(param);
        }
        public IEnumerable<Users_Business_Unit> GetList(Type[] additionalTypes = null)
        {
            return objUsers_Business_Unit_Repository.GetAll(additionalTypes);
        }
    }
    public class Security_Group_Service
    {
        Security_Group_Repository objSecurity_Group_Repository = new Security_Group_Repository();

        public Security_Group_Service()
        {
            this.objSecurity_Group_Repository = new Security_Group_Repository();
        }
        public Security_Group GetSecurity_GroupByID(int? ID, Type[] RelationList = null)
        {
            return objSecurity_Group_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Security_Group> GetTalentList()
        {
            return objSecurity_Group_Repository.GetAll();
        }
        public void AddEntity(Security_Group obj)
        {
            objSecurity_Group_Repository.Add(obj);
        }
        public void UpdateChannel(Security_Group obj)
        {
            objSecurity_Group_Repository.Update(obj);
        }
        public void DeleteCategory(Security_Group obj)
        {
            objSecurity_Group_Repository.Delete(obj);
        }

        public IEnumerable<Security_Group> SearchFor(object param)
        {
            return objSecurity_Group_Repository.SearchFor(param);
        }
        public IEnumerable<Security_Group> GetList(Type[] additionalTypes = null)
        {
            return objSecurity_Group_Repository.GetAll(additionalTypes);
        }
    }
}