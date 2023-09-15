using RightsU_LoadSheet_Export.Entities;
using Dapper;
using ROP.Quotes.DAL.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LoadSheet_Export.Repository
{
    public class ExportToExcelRepositories
    {
        public class USPAL_List_Status_HistoryRepositories : MainRepository<USPAL_RecommendationExportToExcel_Movie>
        {
            public IEnumerable<USPAL_RecommendationExportToExcel_Movie> GetRecommendationData(int AL_Recommendation_Code, int AL_Vendor_Rule_Code)
            {
                List<USPAL_RecommendationExportToExcel_Movie> lstUSPAL_List_Status_History = new List<USPAL_RecommendationExportToExcel_Movie>();

                var param = new DynamicParameters();
                param.Add("@AL_Recommendation_Code", AL_Recommendation_Code);
                param.Add("@AL_Vendor_Rule_Code", AL_Vendor_Rule_Code);
                lstUSPAL_List_Status_History = base.ExecuteSQLProcedure<USPAL_RecommendationExportToExcel_Movie>("USPAL_RecommendationExportToExcel_Movie", param).ToList();

                return lstUSPAL_List_Status_History;
            }


        }

        public class GetRecommendationRulesRepositories : MainRepository<RecommendationRule>
        {
            public IEnumerable<RecommendationRule> GetRecommendationRules(int AL_Recommendation_Code)
            {
                string strSQL = "select DISTINCT alrc.AL_Vendor_Rule_Code, alvr.Rule_Name, alvr.Rule_Type " +
                                "from AL_Recommendation_Content alrc " +
                                "INNER JOIN AL_Vendor_Rule alvr ON alvr.AL_Vendor_Rule_Code = alrc.AL_Vendor_Rule_Code " +
                                "where AL_Recommendation_Code =  " + AL_Recommendation_Code;
                return base.ExecuteSQLStmt<RecommendationRule>(strSQL);
            }
        }

        public class USPAL_RecommendationExportToExcel_ShowRepositories : MainRepository<USPAL_RecommendationExportToExcel_Show>
        {
            public IEnumerable<USPAL_RecommendationExportToExcel_Show> GetRecommendationData_Show(int AL_Recommendation_Code, int AL_Vendor_Rule_Code)
            {
                List<USPAL_RecommendationExportToExcel_Show> lstUSPAL_RecommendationExportToExcel_Show = new List<USPAL_RecommendationExportToExcel_Show>();

                var param = new DynamicParameters();
                param.Add("@AL_Recommendation_Code", AL_Recommendation_Code);
                param.Add("@AL_Vendor_Rule_Code", AL_Vendor_Rule_Code);
                lstUSPAL_RecommendationExportToExcel_Show = base.ExecuteSQLProcedure<USPAL_RecommendationExportToExcel_Show>("USPAL_RecommendationExportToExcel_Show", param).ToList();

                return lstUSPAL_RecommendationExportToExcel_Show;
            }


        }

        public class USPAL_UpdateAL_RecommendationRepositories : MainRepository<string>
        {
            public void USPAL_UpdateAL_Recommendation(int AL_Recommendation_Code, string ExcelFileName)
            {
                var param = new DynamicParameters();
                param.Add("@AL_Recommendation_Code", AL_Recommendation_Code);
                param.Add("@ExcelFileName", ExcelFileName);
                base.ExecuteSQLProcedure<string>("USPAL_UpdateAL_Recommendation", param).ToList();
            }


        }

        public class USPAL_GenerateLoadsheetRepositories : MainRepository<dynamic>
        {
            public IEnumerable<dynamic> USPAL_GenerateLoadsheet(int AL_Load_Sheet_Code, string AL_Lab_Code)
            {
                var param = new DynamicParameters();
                param.Add("@AL_Load_Sheet_Code", AL_Load_Sheet_Code);
                param.Add("@AL_Lab_Code", AL_Lab_Code);
                return base.ExecuteSQLProcedure<dynamic>("USPAL_GenerateLoadsheet", param).ToList();
            }


        }

        public class AL_ProposalRepositories : MainRepository<AL_Proposal>
        {
            public void Add(AL_Proposal entity)
            {
                base.AddEntity(entity);
            }

            public AL_Proposal GetProposal(int Id)
            {
                var obj = new { AL_Proposal_Code = Id };

                //return base.GetById<AL_Proposal, AL_Proposal_Rule, AL_Recommendation, AL_Recommendation_Content>(obj);
                return base.GetById<AL_Proposal, AL_Recommendation, AL_Recommendation_Content>(obj);
            }

            public void Update(AL_Proposal entity)
            {
                AL_Proposal oldObj = GetProposal(entity.AL_Proposal_Code.Value);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Proposal entity)
            {
                base.DeleteEntity(entity);
            }
        }
        public class AL_RecommendationRepositories : MainRepository<AL_Recommendation>
        {
            public void Add(AL_Recommendation entity)
            {
                base.AddEntity(entity);
            }

            public AL_Recommendation GetProposal(int Id)
            {
                var obj = new { AL_Recommendation_Code = Id };

                return base.GetById<AL_Recommendation, AL_Recommendation_Content>(obj);
            }

            public IEnumerable<AL_Recommendation> GetAllRecommendation()
            {
                return base.GetAll<AL_Recommendation, AL_Recommendation_Content>();
            }

            public void Update(AL_Recommendation entity)
            {
                AL_Recommendation oldObj = GetProposal(entity.AL_Recommendation_Code.Value);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Recommendation entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class AL_RecommendationContentRepositories : MainRepository<AL_Recommendation_Content>
        {
            public void Add(AL_Recommendation_Content entity)
            {
                base.AddEntity(entity);
            }

            public AL_Recommendation_Content GetAL_Recommendation_Content(int Id)
            {
                var obj = new { AL_Recommendation_Content_Code = Id };

                return base.GetById<AL_Recommendation_Content>(obj);
            }

            public IEnumerable<AL_Recommendation_Content> GetAllRecommendation()
            {
                return base.GetAll<AL_Recommendation_Content>();
            }

            public void Update(AL_Recommendation_Content entity)
            {
                AL_Recommendation_Content oldObj = GetAL_Recommendation_Content(entity.AL_Recommendation_Content_Code.Value);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Recommendation_Content entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class AL_Load_SheetRepositories : MainRepository<AL_Load_Sheet>
        {
            public void Add(AL_Load_Sheet entity)
            {
                base.AddEntity(entity);
            }

            public AL_Load_Sheet GetLoadSheet(int Id)
            {
                var obj = new { AL_Load_Sheet_Code = Id };

                //return base.GetById<AL_Load_Sheet, AL_Load_Sheet_Rule, AL_Recommendation, AL_Recommendation_Content>(obj);
                return base.GetById<AL_Load_Sheet,AL_Load_Sheet_Details>(obj);
            }
            public IEnumerable<AL_Load_Sheet> GetALLAL_Load_Sheet()
            {
                return base.GetAll<AL_Load_Sheet, AL_Load_Sheet_Details>();
            }
            public void Update(AL_Load_Sheet entity)
            {
                AL_Load_Sheet oldObj = GetLoadSheet(entity.AL_Load_Sheet_Code.Value);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Load_Sheet entity)
            {
                base.DeleteEntity(entity);
            }

            public void GetDataWithSQLStmt(string strSQL)
            {
                base.ExecuteSQLStmt<dynamic>(strSQL);
            }
        }

        public class AL_Booking_SheetRepositories : MainRepository<AL_Booking_Sheet>
        {
            public void Add(AL_Booking_Sheet entity)
            {
                base.AddEntity(entity);
            }

            public AL_Booking_Sheet GetBookingSheet(int Id)
            {
                var obj = new { AL_Booking_Sheet_Code = Id };

                //return base.GetById<AL_Booking_Sheet, AL_Booking_Sheet_Rule, AL_Recommendation, AL_Recommendation_Content>(obj);
                return base.GetById<AL_Booking_Sheet, AL_Booking_Sheet_Details>(obj);
            }
            public IEnumerable<AL_Booking_Sheet> GetALLAL_Booking_Sheet()
            {
                return base.GetAll<AL_Booking_Sheet, AL_Booking_Sheet_Details>();
            }
            public void Update(AL_Booking_Sheet entity)
            {
                AL_Booking_Sheet oldObj = GetBookingSheet(entity.AL_Booking_Sheet_Code);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Booking_Sheet entity)
            {
                base.DeleteEntity(entity);
            }
        }

        public class AL_Booking_Sheet_DetailsRepositories : MainRepository<AL_Booking_Sheet_Details>
        {
            public void Add(AL_Booking_Sheet_Details entity)
            {
                base.AddEntity(entity);
            }

            public AL_Booking_Sheet_Details GetBookingSheetDetails(int Id)
            {
                var obj = new { AL_Booking_Sheet_Details_Code = Id };

                //return base.GetById<AL_Booking_Sheet_Details, AL_Booking_Sheet_Details_Rule, AL_Recommendation, AL_Recommendation_Content>(obj);
                return base.GetById<AL_Booking_Sheet_Details>(obj);
            }
            public IEnumerable<AL_Booking_Sheet_Details> GetALLAL_Booking_Sheet_Details()
            {
                return base.GetAll<AL_Booking_Sheet_Details>();
            }
            public void Update(AL_Booking_Sheet_Details entity)
            {
                AL_Booking_Sheet_Details oldObj = GetBookingSheetDetails(entity.AL_Booking_Sheet_Details_Code);
                base.UpdateEntity(oldObj, entity);
            }

            public void Delete(AL_Booking_Sheet_Details entity)
            {
                base.DeleteEntity(entity);
            }

            public IEnumerable<AL_Booking_Sheet_Details> SearchFor(object param)
            {
                return base.SearchForEntity<AL_Booking_Sheet_Details>(param);
            }
        }
    }
}
