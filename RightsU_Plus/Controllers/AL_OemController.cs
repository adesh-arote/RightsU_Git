using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class AL_OemController : BaseController
    {

        #region Sessions
        private List<RightsU_Entities.AL_OEM> lstOem_Searched
        {
            get
            {
                if (Session["lstOem_Searched"] == null)
                    Session["lstOem_Searched"] = new List<RightsU_Entities.AL_OEM>();
                return (List<RightsU_Entities.AL_OEM>)Session["lstOem_Searched"];
            }
            set { Session["lstOem_Searched"] = value; }
        }

        List<USP_Bind_Extend_Column_Grid_Result> OEMExtended
        {
            get
            {
                if (Session["OEMExtended"] == null)
                    Session["OEMExtended"] = new List<USP_Bind_Extend_Column_Grid_Result>();
                return (List<USP_Bind_Extend_Column_Grid_Result>)Session["OEMExtended"];
            }
            set
            {
                Session["OEMExtended"] = value;
            }
        }

        private List<RightsU_Entities.Map_Extended_Columns> lstAddedExtendedColumns
        {
            get
            {
                if (Session["lstAddedExtendedColumns"] == null)
                    Session["lstAddedExtendedColumns"] = new List<RightsU_Entities.Map_Extended_Columns>();
                return (List<RightsU_Entities.Map_Extended_Columns>)Session["lstAddedExtendedColumns"];
            }
            set { Session["lstAddedExtendedColumns"] = value; }
        }
        #endregion

        #region UI_Methods
        public ActionResult Index()
        {
            ViewBag.Message = "";
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Company Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Company Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            if (Session["Message"] != null)
            {                                            //-----To add edit success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }
            return View();
        }

        public PartialViewResult BindALOemList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.AL_OEM> lst = new List<RightsU_Entities.AL_OEM>();
            int RecordCount = 0;
            RecordCount = lstOem_Searched.Count;
            Session["TotalRecord"] = RecordCount;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstOem_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lst = lstOem_Searched.OrderBy(o => o.Company_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else
                {
                    lst = lstOem_Searched.OrderByDescending(o => o.Company_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }
            return PartialView("~/Views/AL_Oem/_BindALOemList.cshtml", lst);
        }

        public void FetchData()
        {
            AL_OEM_Service aL_OEM_Service = new AL_OEM_Service(objLoginEntity.ConnectionStringName);
            lstOem_Searched = aL_OEM_Service.SearchFor(x => true).OrderBy(o => o.AL_OEM_Code).ToList();
        }

        public JsonResult SearchALOem(string searchText)
        {
            FetchData();
            if (!string.IsNullOrEmpty(searchText))
            {
                lstOem_Searched = lstOem_Searched.Where(w => w.Company_Name.ToUpper().Contains(searchText.ToUpper())
                || w.Company_Short_Name != null && w.Company_Short_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
            {
                FetchData();
            }
            var obj = new
            {
                Record_Count = lstOem_Searched.Count
            };
            return Json(obj);
        }

        private int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }
        #endregion

        #region View Methods
        [HttpPost]
        public PartialViewResult BindAddEditView(string CommandName, int ALOemCode)
        {
            lstAddedExtendedColumns = null;
            OEMExtended = null;

            AL_OEM aL_OEM = new AL_OEM();
            AL_OEM_Service aL_OEM_Service = new AL_OEM_Service(objLoginEntity.ConnectionStringName);
            if (CommandName == "ADD")
            {
                ViewBag.ViewType = "Add";
            }
            if (CommandName == "EDIT" || CommandName == "DELETE" || CommandName == "VIEW")
            {
                if (CommandName == "EDIT")
                {
                    ViewBag.ViewType = "Edit";
                }
                if (CommandName == "DELETE")
                {
                    ViewBag.ViewType = "Delete";
                }
                if (CommandName == "VIEW")
                {
                    ViewBag.ViewType = "View";
                }
                aL_OEM = aL_OEM_Service.GetById(ALOemCode);
            }
            return PartialView("~/Views/AL_Oem/_AddEditALOem.cshtml", aL_OEM);
        }

        [HttpPost]
        public PartialViewResult AddEditFieldValue(string CommandName, int Id)
        {
            Map_Extended_Columns_Service map_Extended_Columns_Service = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName);

            if (CommandName == "EDIT" || CommandName == "DELETE" || CommandName == "VIEW")
            {
                OEMExtended = new USP_Service(objLoginEntity.ConnectionStringName).USP_Bind_Extend_Column_Grid(Id).ToList();
                if (OEMExtended.Count != 0)
                {
                    lstAddedExtendedColumns = map_Extended_Columns_Service.SearchFor(y => y.Record_Code == Id).ToList();
                }
                if (CommandName == "DELETE" || CommandName == "VIEW")
                {
                    ViewBag.HideButtons = "ButtonHide";
                }
            }
            return PartialView("~/Views/AL_Oem/_AddEditFieldValue.cshtml", OEMExtended);
        }
        #endregion

        #region BindFieldRowMethods
        public string BindNewRowDdl(int ColumnCode, int RowNum, string IsExists, int Ext_Grp_Code)
        {
            int Column_Code = Convert.ToInt32(ColumnCode);
            //string str_Program_Category_Value = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Parameter_Name == "Program_Category_Value" && i.IsActive == "Y").Select(s => s.Parameter_Value).FirstOrDefault();

            List<int> ColumnNotInCode;
            if (IsExists != "A")
                ColumnNotInCode = OEMExtended.Where(y => y.Columns_Code != ColumnCode).Select(x => x.Columns_Code).Distinct().ToList();
            else
                ColumnNotInCode = OEMExtended.Select(x => x.Columns_Code).Distinct().ToList();

            List<RightsU_Entities.Extended_Columns> lstExtendedColumns = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            List<RightsU_Entities.Extended_Group> lstExtendedGroups = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Module_Code == Ext_Grp_Code).ToList();
            List<int> UsedExtendedColumns = new List<int>();
            foreach (Extended_Group eg in lstExtendedGroups)
            {
                foreach (Extended_Group_Config egc in eg.Extended_Group_Config)
                {
                    UsedExtendedColumns.Add(egc.Extended_Columns.Columns_Code);
                }
            }

            lstExtendedColumns = lstExtendedColumns.Where(w => UsedExtendedColumns.Any(a => w.Columns_Code == a)).ToList();
            List<Extended_Columns> EditObjList = lstExtendedColumns;

            //------To Remove ColumnCode
            if (lstAddedExtendedColumns.Count > 0)
            {
                if (ColumnCode == 0)
                {
                    lstExtendedColumns = lstExtendedColumns.Where(w => !lstAddedExtendedColumns.Any(a => w.Columns_Code == a.Columns_Code && a.EntityState != State.Deleted)).ToList();
                }
                if (ColumnCode != 0)
                {
                    lstExtendedColumns = lstExtendedColumns.Where(w => !lstAddedExtendedColumns.Any(a => w.Columns_Code == a.Columns_Code && a.EntityState != State.Deleted)).ToList();
                    Extended_Columns objM = EditObjList.Where(a => a.Columns_Code == ColumnCode).FirstOrDefault();
                    lstExtendedColumns.Add(objM);
                }
            }

            string FieldNameDDL = "";

            if (RowNum != 0)
                FieldNameDDL = "<select id='" + RowNum + "_ddlFieldNameList' class='form_input chosen-select' onchange='ControlType(0,$(this).val())'> ";

            FieldNameDDL += " <option value='0' selected>Please Select</option> ";

            //if (ColumnCode == Convert.ToInt32(str_Program_Category_Value))
            //{
            //    FieldNameDDL = "<select id='" + RowNum + "_ddlFieldNameList' class='form_input chosen-select' onchange='ControlType(" + str_Program_Category_Value + ",$(this).val())' disabled> ";
            //    FieldNameDDL += "<option value='17' selected>Program Category";
            //}

            for (int i = 0; i < lstExtendedColumns.Count; i++)
            {
                if (lstExtendedColumns[i].Columns_Code == Column_Code)
                    FieldNameDDL += " <option value='" + lstExtendedColumns[i].Control_Type + "~" + lstExtendedColumns[i].Columns_Code + "~" + lstExtendedColumns[i].Is_Ref + "~" + lstExtendedColumns[i].Is_Defined_Values + "~" + lstExtendedColumns[i].Is_Multiple_Select + "~" + lstExtendedColumns[i].Ref_Table + "~" + lstExtendedColumns[i].Ref_Display_Field + "~" + lstExtendedColumns[i].Ref_Value_Field + "~" + lstExtendedColumns[i].Additional_Condition + "~" + lstExtendedColumns[i].Is_Add_OnScreen + "~" + lstExtendedColumns[i].Columns_Name + "' selected>" + lstExtendedColumns[i].Columns_Name + "</option> ";
                else
                    FieldNameDDL += " <option value='" + lstExtendedColumns[i].Control_Type + "~" + lstExtendedColumns[i].Columns_Code + "~" + lstExtendedColumns[i].Is_Ref + "~" + lstExtendedColumns[i].Is_Defined_Values + "~" + lstExtendedColumns[i].Is_Multiple_Select + "~" + lstExtendedColumns[i].Ref_Table + "~" + lstExtendedColumns[i].Ref_Display_Field + "~" + lstExtendedColumns[i].Ref_Value_Field + "~" + lstExtendedColumns[i].Additional_Condition + "~" + lstExtendedColumns[i].Is_Add_OnScreen + "~" + lstExtendedColumns[i].Columns_Name + "'>" + lstExtendedColumns[i].Columns_Name + "</option> ";
            }
            if (RowNum != 0)
                FieldNameDDL += "</select>";
            return FieldNameDDL;
        }

        public JsonResult BinddlColumnsValue(string ColumnsCode, string AdditionalCondition)
        {
            int Column_Code = Convert.ToInt32(ColumnsCode);
            var lstextCol = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Column_Code)
                .Select(y => new { ColumnsValue = y.Columns_Value, Columns_Value_Code = y.Columns_Value_Code }).ToList();
            //ExtendedColumnsCode = Column_Code;
            return Json(lstextCol, JsonRequestBehavior.AllowGet);
        }

        public JsonResult BindddlExtendedTalent(string ColumnsCode, string AdditionalCondition)
        {
            int RoleCode = 0;

            if (AdditionalCondition != "")
                RoleCode = Convert.ToInt32(AdditionalCondition);
            var lstextCol = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Role.Any(TR => TR.Role_Code == RoleCode)).Where(y => y.Is_Active == "Y")
                .Select(i => new { ColumnsValue = i.Talent_Name, Columns_Value_Code = i.Talent_Code }).ToList();
            return Json(lstextCol, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveExtendedRecord(string hdnExtendedColumnsCode, string hdnColumnValueCode, string hdnControlType, string hdnIsRef, string hdnIsDefined_Values, string hdnIsMultipleSelect,
           string hdnRefTable, string hdnRefDisplayField, string hdnRefValueField, string AdditionalCondition, string hdnExtendedColumnName, string hdnName, string hdnType, string hdnRowNum, string hdnMEColumnCode, string hdnExtendedColumnValue)
        {
            USP_Bind_Extend_Column_Grid_Result obj;
            string Message = "";
            if (hdnColumnValueCode == null || hdnColumnValueCode == "")
                hdnColumnValueCode = "0";
            string[] arrColumnsValueCode = hdnColumnValueCode.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            int ColumnCode = Convert.ToInt32(hdnExtendedColumnsCode);
            if (hdnType == "A" || hdnType == "")
            {
                obj = new USP_Bind_Extend_Column_Grid_Result();
                obj.Columns_Code = ColumnCode;
                if (hdnColumnValueCode.Split(',').Count() <= 1)
                    obj.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                obj.Is_Ref = hdnIsRef;
                obj.Is_Defined_Values = hdnIsDefined_Values;
                obj.Is_Multiple_Select = hdnIsMultipleSelect;
                obj.Ref_Table = hdnRefTable;
                obj.Ref_Display_Field = hdnRefDisplayField;
                obj.Ref_Value_Field = hdnRefValueField;
                obj.Columns_Name = hdnExtendedColumnName;
                obj.Name = hdnName;

                OEMExtended.Add(obj);

                Map_Extended_Columns objMapExtendedColumns = new Map_Extended_Columns();
                objMapExtendedColumns.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
                objMapExtendedColumns.Table_Name = "AL_OEM";
                objMapExtendedColumns.Is_Multiple_Select = hdnIsMultipleSelect;
                objMapExtendedColumns.EntityState = State.Added;

                if (hdnRefTable.Trim().ToUpper() == "TALENT" && hdnIsMultipleSelect.Trim().ToUpper() == "Y")
                {
                    foreach (string str in arrColumnsValueCode)
                    {
                        Map_Extended_Columns_Details objMapExtDet = new Map_Extended_Columns_Details();
                        objMapExtDet.Columns_Value_Code = Convert.ToInt32(str);
                        objMapExtDet.EntityState = State.Added;
                        objMapExtendedColumns.Map_Extended_Columns_Details.Add(objMapExtDet);
                    }
                }
                else if (hdnIsDefined_Values.Trim().ToUpper() == "N" && hdnControlType.Trim().ToUpper() == "TXT")
                {
                    objMapExtendedColumns.Column_Value = hdnName;

                    objMapExtendedColumns.Columns_Value_Code = null;
                }
                else if ((hdnRefTable.Trim().ToUpper() == "TALENT" || hdnRefTable.Trim().ToUpper() == "") && hdnIsMultipleSelect.Trim().ToUpper() == "N")
                {
                    objMapExtendedColumns.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                }
                if (hdnRefTable.Trim().ToUpper() == "Extended_Columns_Value".ToUpper() && hdnIsMultipleSelect.Trim().ToUpper() == "Y")
                {
                    foreach (string str in arrColumnsValueCode)
                    {
                        Map_Extended_Columns_Details objMapExtDet = new Map_Extended_Columns_Details();
                        objMapExtDet.Columns_Value_Code = Convert.ToInt32(str);
                        objMapExtDet.EntityState = State.Added;
                        objMapExtendedColumns.Map_Extended_Columns_Details.Add(objMapExtDet);
                    }
                }

                lstAddedExtendedColumns.Add(objMapExtendedColumns);
            }
            else
            {
                int OldColumnCode = 0;

                int RowNum = Convert.ToInt32(hdnRowNum);
                obj = OEMExtended[RowNum - 1];

                OldColumnCode = obj.Columns_Code;

                if (hdnExtendedColumnsCode != "")
                    obj.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
                if (hdnColumnValueCode != "")
                {
                    if (hdnColumnValueCode.Split(',').Count() <= 1)
                        obj.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                }
                obj.Is_Ref = hdnIsRef;
                obj.Is_Defined_Values = hdnIsDefined_Values;
                obj.Is_Multiple_Select = hdnIsMultipleSelect;
                obj.Ref_Table = hdnRefTable;
                obj.Ref_Display_Field = hdnRefDisplayField;
                obj.Ref_Value_Field = hdnRefValueField;
                obj.Columns_Name = hdnExtendedColumnName;
                obj.Name = hdnName;

                //if(hdnType == "D")
                //{
                //    OEMExtended.Remove(obj);
                //}


                int MapExtendedColumnCode = 0;

                if (hdnMEColumnCode != "")
                    MapExtendedColumnCode = Convert.ToInt32(hdnMEColumnCode);

                Map_Extended_Columns objMEc;
                try
                {
                    //if (hdnMEColumnCode != "")
                    //   objMEc = lstDataBaseExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.EntityState != State.Added).FirstOrDefault();
                    objMEc = lstAddedExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.EntityState != State.Added).FirstOrDefault();

                    if (objMEc != null)
                    {
                        objMEc.EntityState = State.Modified;
                        objMEc.Columns_Code = ColumnCode;
                        if (hdnColumnValueCode.Split(',').Count() <= 0)
                            objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);

                        var FirstList = objMEc.Map_Extended_Columns_Details.Select(y => y.Columns_Value_Code.ToString()).Distinct().ToList();
                        var SecondList = arrColumnsValueCode.Distinct().ToList();
                        var Diff = FirstList.Except(SecondList);
                        
                        foreach (string str in Diff)
                        {
                            if (str != "" && str != " ")
                            {
                                int ColumnValCode = Convert.ToInt32(str);
                                objMEc.Map_Extended_Columns_Details.Where(y => y.Columns_Value_Code == ColumnValCode).ToList().ForEach(x => x.EntityState = State.Deleted);
                            }
                        }

                        foreach (string str in arrColumnsValueCode)
                        {
                            if (str != "" && str != "0" && str != " ")
                            {
                                Map_Extended_Columns_Details objMECD;

                                objMECD = objMEc.Map_Extended_Columns_Details.Where(p => p.Columns_Value_Code == Convert.ToInt32(str) && p.EntityState != State.Added).FirstOrDefault();
                                if (objMECD != null)
                                {
                                    if (hdnType == "D")
                                        objMECD.EntityState = State.Deleted;
                                    else
                                        objMECD.EntityState = State.Modified;

                                    objMECD.Columns_Value_Code = Convert.ToInt32(str);
                                }
                                else
                                {
                                    objMECD = objMEc.Map_Extended_Columns_Details.Where(p => p.Columns_Value_Code == Convert.ToInt32(str) && p.EntityState == State.Added).FirstOrDefault();
                                    if (objMECD == null)
                                    {
                                        if ((hdnRefTable.Trim().ToUpper() == "TALENT" || hdnRefTable.Trim().ToUpper() == "") && hdnIsMultipleSelect.Trim().ToUpper() == "N")
                                        {
                                            if (hdnControlType.Trim().ToUpper() != "TXT")
                                            {
                                                objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                                                objMEc.Columns_Code = ColumnCode;
                                                objMEc.Column_Value = "";
                                            }
                                            else
                                            {
                                                objMEc.Columns_Value_Code = null;
                                                objMEc.Column_Value = hdnExtendedColumnValue;
                                            }
                                            objMEc.EntityState = State.Modified;
                                            if (objMEc.Map_Extended_Columns_Details.Count > 0)
                                            {
                                                foreach (Map_Extended_Columns_Details objMECD_inner in objMEc.Map_Extended_Columns_Details)
                                                {
                                                    objMECD_inner.EntityState = State.Deleted;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            objMECD = new Map_Extended_Columns_Details();
                                            objMECD.Columns_Value_Code = Convert.ToInt32(str);

                                            int MapExtCode;
                                            if (objMEc.Map_Extended_Columns_Details.Count > 0)
                                            {
                                                //MapExtCode =(int) objMEc.Map_Extended_Columns_Details.Select(x => x.Map_Extended_Columns_Code).Distinct().SingleOrDefault();
                                                if (hdnMEColumnCode != "")
                                                    objMECD.Map_Extended_Columns_Code = Convert.ToInt32(hdnMEColumnCode);
                                            }
                                            else
                                            {
                                                objMECD.Map_Extended_Columns_Code = null;
                                            }
                                            if (hdnType == "D")
                                            {
                                                objMECD.EntityState = State.Deleted;
                                            }
                                            else
                                                objMECD.EntityState = State.Added;
                                            objMEc.Map_Extended_Columns_Details.Add(objMECD);
                                        }
                                    }
                                }
                            }
                        }
                        if (hdnControlType.Trim().ToUpper() == "TXT")
                        {
                            objMEc.Columns_Value_Code = null;
                            objMEc.Column_Value = hdnExtendedColumnValue;
                            objMEc.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
                        }
                        if (hdnType == "D")
                        {
                            USP_Bind_Extend_Column_Grid_Result objDeleteUBECD = OEMExtended.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
                            //OEMExtended.Remove(objDeleteUBECD);
                            try
                            {

                                int code = Convert.ToInt32(objDeleteUBECD.Map_Extended_Columns_Code);
                                if (code > 0)
                                {
                                    lstAddedExtendedColumns.ForEach(t => { if (t.Map_Extended_Columns_Code == code) t.EntityState = State.Deleted; });
                                }
                            }
                            catch { }
                        }
                    }
                    else
                    {
                        //objMEc = lstDataBaseExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.EntityState == State.Added).FirstOrDefault();
                        //if (objMEc == null)
                        //{
                        objMEc = lstAddedExtendedColumns.Where(y => y.Columns_Code == OldColumnCode).FirstOrDefault();
                        objMEc.Columns_Code = ColumnCode;
                        if (hdnColumnValueCode.Split(',').Count() <= 0)
                            objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);


                        if (objMEc.Map_Extended_Columns_Details.Count > 0)
                        {
                            if (arrColumnsValueCode.Length < 1)
                            {
                                foreach (Map_Extended_Columns_Details objMECD in objMEc.Map_Extended_Columns_Details)
                                {
                                    objMECD.Columns_Value_Code = 0;
                                }
                            }
                            else
                            {
                                foreach (string str in arrColumnsValueCode)
                                {
                                    int ColumnValueCode = Convert.ToInt32(str);
                                    Map_Extended_Columns_Details objMECD = objMEc.Map_Extended_Columns_Details.Where(x => x.Columns_Value_Code == ColumnValueCode).FirstOrDefault();

                                    if (objMECD == null)
                                    {
                                        objMECD = new Map_Extended_Columns_Details();
                                        objMECD.Columns_Value_Code = Convert.ToInt32(str);
                                        objMEc.Map_Extended_Columns_Details.Add(objMECD);
                                    }
                                }
                            }
                        }
                        if (hdnType == "D")
                        {
                            lstAddedExtendedColumns.Remove(objMEc);
                        }
                    }
                    //}
                }
                catch
                {
                    objMEc = lstAddedExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
                    if (objMEc != null)
                    {
                        if (hdnType == "D")
                            objMEc.EntityState = State.Deleted;
                        else
                            objMEc.EntityState = State.Modified;
                    }
                }
            }

            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (Message == "")
            {
                if (hdnType == "A" || hdnType == "")
                    Message = "Record added successfully";
                else if (hdnType == "D")
                    Message = "Record deleted successfully";
                else if (hdnType == "E")
                    Message = "Record updated successfully";
                objJson.Add("Message", Message);
                objJson.Add("Error", "");
                int Count = lstAddedExtendedColumns.Where(w => w.EntityState != State.Deleted).Count();
                objJson.Add("RecordCount", Count);
            }
            else
            {
                objJson.Add("Error", Message);
                objJson.Add("Message", "");
            }
            return Json(objJson);
        }
        #endregion

        #region Save and Delete
        [HttpPost]
        public ActionResult SaveOEM(int Id, AL_OEM obj)
        {
            try
            {
                string Message = "", Status = "";

                AL_OEM aL_OEM = new AL_OEM();
                AL_OEM_Service aL_OEM_Service = new AL_OEM_Service(objLoginEntity.ConnectionStringName);
                Map_Extended_Columns_Service Map_Extended_Columns_Service = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName);

                string Action = "C";
                VM_AL_OEM objVmAlOEM = new VM_AL_OEM();

                if (Id == 0)
                {
                    if (lstAddedExtendedColumns.Count == 0)
                    {
                        Status = "E";
                        Message = "Please Add Field Values";
                        var ObjMEC = new
                        {
                            Status = Status,
                            Message = Message
                        };
                        return Json(ObjMEC);
                    }
                    aL_OEM.Company_Name = obj.Company_Name;
                    aL_OEM.Company_Short_Name = obj.Company_Short_Name;
                    aL_OEM.Inserted_On = DateTime.Now;
                    aL_OEM.Inserted_By = objLoginUser.Users_Code;
                    aL_OEM.Last_Updated_Time = DateTime.Now;
                    aL_OEM.Last_Action_By = objLoginUser.Users_Code;

                    aL_OEM.EntityState = State.Added;

                    dynamic resultSet;
                    if (!aL_OEM_Service.Save(aL_OEM, out resultSet))
                    {
                        Message = resultSet;
                        Status = "E";
                    }
                    else
                    {                        
                        objVmAlOEM.AL_OEM = aL_OEM;

                        List<AL_OEM> lisOem = aL_OEM_Service.SearchFor(s => true).ToList();
                        var lastId = lisOem.OrderBy(o => o.AL_OEM_Code).LastOrDefault();

                        foreach (Map_Extended_Columns MECobj in lstAddedExtendedColumns)
                        {
                            MECobj.Record_Code = lastId.AL_OEM_Code;
                            if (!Map_Extended_Columns_Service.Save(MECobj, out resultSet))
                            {
                                Message = resultSet;
                                Status = "E";
                            }
                            else
                            {
                                Session["Message"] = objMessageKey.RecordAddedSuccessfully;
                                Status = "S";
                                Action = "C";
                            }
                        }

                        objVmAlOEM.Map_Extended_Columns = lstAddedExtendedColumns;
                    }
                }
                else
                {
                    if (lstAddedExtendedColumns.Count == 0)
                    {
                        Status = "E";
                        Message = "Please Add Field Values";
                        var ObjMEC = new
                        {
                            Status = Status,
                            Message = Message
                        };
                        return Json(ObjMEC);
                    }

                    aL_OEM = aL_OEM_Service.GetById(Id);

                    aL_OEM.Company_Name = obj.Company_Name;
                    aL_OEM.Company_Short_Name = obj.Company_Short_Name;
                    aL_OEM.Inserted_On = aL_OEM.Inserted_On;
                    aL_OEM.Inserted_By = aL_OEM.Inserted_By;
                    aL_OEM.Last_Updated_Time = DateTime.Now;
                    aL_OEM.Last_Action_By = objLoginUser.Users_Code;

                    aL_OEM.EntityState = State.Modified;

                    dynamic resultSet;
                    if (!aL_OEM_Service.Save(aL_OEM, out resultSet))
                    {
                        Message = resultSet;
                        Status = "E";
                    }
                    else
                    {                        
                        objVmAlOEM.AL_OEM = aL_OEM;
                        //  List<Map_Extended_Columns> SaveToDBList = lstAddedExtendedColumns.Union(lstDataBaseExtendedColumns).ToList();
                        foreach (Map_Extended_Columns MECobj in lstAddedExtendedColumns)
                        {
                            Map_Extended_Columns DBMEC = new Map_Extended_Columns();
                            if (MECobj.Map_Extended_Columns_Code > 0)
                            {
                                DBMEC = Map_Extended_Columns_Service.GetById(MECobj.Map_Extended_Columns_Code);
                            }
                            DBMEC.Record_Code = Id;
                            DBMEC.Table_Name = MECobj.Table_Name;
                            DBMEC.Columns_Code = MECobj.Columns_Code;
                            DBMEC.Columns_Value_Code = MECobj.Columns_Value_Code;
                            DBMEC.Column_Value = MECobj.Column_Value;
                            DBMEC.Is_Multiple_Select = MECobj.Is_Multiple_Select;
                            DBMEC.Row_No = MECobj.Row_No;
                            DBMEC.EntityState = MECobj.EntityState;
                            foreach (Map_Extended_Columns_Details MECD in MECobj.Map_Extended_Columns_Details)
                            {
                                if (MECD.EntityState == State.Modified)
                                {
                                    Map_Extended_Columns_Details objDB = new Map_Extended_Columns_Details();
                                    objDB = DBMEC.Map_Extended_Columns_Details.Where(w => w.Map_Extended_Columns_Details_Code == MECD.Map_Extended_Columns_Details_Code).FirstOrDefault();
                                    objDB.Columns_Value_Code = MECD.Columns_Value_Code;
                                    objDB.EntityState = State.Modified;
                                }
                                if (MECD.EntityState == State.Added)
                                {
                                    DBMEC.Map_Extended_Columns_Details.Add(MECD);
                                }
                                if (MECD.EntityState == State.Deleted)
                                {
                                    Map_Extended_Columns_Details objDB = new Map_Extended_Columns_Details();
                                    objDB = DBMEC.Map_Extended_Columns_Details.Where(w => w.Map_Extended_Columns_Details_Code == MECD.Map_Extended_Columns_Details_Code).FirstOrDefault();
                                    objDB.Columns_Value_Code = MECD.Columns_Value_Code;
                                    objDB.EntityState = State.Deleted;
                                }
                            }

                            if (!Map_Extended_Columns_Service.Save(DBMEC, out resultSet))
                            {
                                Message = resultSet;
                                Status = "E";
                            }
                            else
                            {
                                Session["Message"] = objMessageKey.Recordupdatedsuccessfully;
                                Status = "S";
                                Action = "U";
                            }

                            objVmAlOEM.Map_Extended_Columns = lstAddedExtendedColumns;
                        }
                    }
                }

                if(Status == "S")
                {
                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objVmAlOEM);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForALOEM), Convert.ToInt32(aL_OEM.AL_OEM_Code), LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {

                    }
                }

                var Obj = new
                {
                    Status = Status,
                    Message = Message
                };

                return Json(Obj);
            }
            catch (Exception ex)
            {
                string Message = ex.Message;
                throw;
            }
        }

        [HttpPost]
        public ActionResult DeleteAlOem(int Id)
        {
            try
            {
                string Message = "", Status = "";
                AL_OEM aL_OEM = new AL_OEM();
                AL_OEM_Service aL_OEM_Service = new AL_OEM_Service(objLoginEntity.ConnectionStringName);
                Map_Extended_Columns_Service map_Extended_Columns_Service = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName);
                aL_OEM = aL_OEM_Service.GetById(Id);
                aL_OEM.EntityState = State.Deleted;

                string Action = "D";
                VM_AL_OEM objVmAlOEM = new VM_AL_OEM();

                dynamic resultSet;
                if (!aL_OEM_Service.Delete(aL_OEM, out resultSet))
                {
                    Message = resultSet;
                    Status = "E";
                }
                else
                {
                    objVmAlOEM.AL_OEM = aL_OEM;

                    foreach (Map_Extended_Columns MEC in lstAddedExtendedColumns)
                    {
                        Map_Extended_Columns DBMEC = new Map_Extended_Columns();
                        DBMEC = map_Extended_Columns_Service.GetById(MEC.Map_Extended_Columns_Code);
                        DBMEC.EntityState = State.Deleted;

                        if (DBMEC.Map_Extended_Columns_Details.Count > 0)
                        {
                            foreach (Map_Extended_Columns_Details MECD in DBMEC.Map_Extended_Columns_Details)
                            {
                                //Map_Extended_Columns_Details objDB = new Map_Extended_Columns_Details();
                                //objDB = DBMEC.Map_Extended_Columns_Details.Where(w => w.Map_Extended_Columns_Details_Code == MECD.Map_Extended_Columns_Details_Code).FirstOrDefault();
                                //objDB.Columns_Value_Code = MECD.Columns_Value_Code;
                                //objDB.EntityState = State.Deleted; 
                                MECD.EntityState = State.Deleted;
                            }
                        }
                        if (!map_Extended_Columns_Service.Save(DBMEC, out resultSet))
                        {
                            Message = resultSet;
                            Status = "E";
                        }
                        else
                        {
                            Session["Message"] = objMessageKey.RecordDeletedsuccessfully;
                            Status = "S";
                        }
                        objVmAlOEM.Map_Extended_Columns = lstAddedExtendedColumns;
                    }
                }

                if (Status == "S")
                {
                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objVmAlOEM);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForALOEM), Convert.ToInt32(aL_OEM.AL_OEM_Code), LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {

                    }
                }

                var Obj = new
                {
                    Status = Status,
                    Message = Message
                };

                return Json(Obj);
            }
            catch (Exception ex)
            {
                string Message = ex.Message;
                throw;
            }

        }
        #endregion

        [HttpPost]
        public JsonResult CheckRecordLock(int AL_OemCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (AL_OemCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(AL_OemCode, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }
            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

    }

    public partial class VM_AL_OEM
    {
        public virtual AL_OEM AL_OEM { get; set; }
        public virtual ICollection<Map_Extended_Columns> Map_Extended_Columns { get; set; }
    }
}