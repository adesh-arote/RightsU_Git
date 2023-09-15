using RightsU_Recommendation_Export_CA.Entities;
using RightsU_Recommendation_Export_CA.WebReference;
using Newtonsoft.Json;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using static RightsU_Recommendation_Export_CA.Repository.ExportToExcelRepositories;
using System.IO.Compression;

namespace RightsU_Recommendation_Export_CA
{
    public class Program
    {
        public static void Main(string[] args)
        {
            AL_RecommendationRepositories objAL_RecommendationRepositories = new AL_RecommendationRepositories();
            AL_ProposalRepositories objAL_ProposalRepositories = new AL_ProposalRepositories();
            List<AL_Recommendation> lstAL_Recommendation = new List<AL_Recommendation>();
            USPAL_UpdateAL_RecommendationRepositories objUSPAL_UpdateAL_RecommendationRepositories = new USPAL_UpdateAL_RecommendationRepositories();

            lstAL_Recommendation = objAL_RecommendationRepositories.GetAllRecommendation().Where(x => (x.Workflow_status == "A" || x.Workflow_status == "F") && String.IsNullOrEmpty(x.Excel_File) == true).ToList(); //x.AL_Recommendation_Code == 4165
            foreach (var item in lstAL_Recommendation)
            {
                int AL_Recommendation_Code = item.AL_Recommendation_Code ?? 0;
                int AL_Proposal_Code = item.AL_Proposal_Code;
                int Refresh_Cycle_No = item.Refresh_Cycle_No;

                string ExcelName = "";
                string PDFName = "";
                string ExcelNameShow = "";
                string Destination = "";
                string ZipFileName = "";

                string ProposalID = objAL_ProposalRepositories.GetProposal(item.AL_Proposal_Code).Proposal_No;
                Destination = ConfigurationManager.AppSettings["UploadFilePath"] + ProposalID + " (CY-" + Refresh_Cycle_No + ")" + ".zip";

                ExcelName = ExportToExcelByRecommendation(AL_Recommendation_Code, AL_Proposal_Code, Refresh_Cycle_No);
                ExcelNameShow = ExportToExcelByRecommendationShow(AL_Recommendation_Code, AL_Proposal_Code, Refresh_Cycle_No); 
                PDFName = GenerateRecomPDFTitlewise(AL_Recommendation_Code, ProposalID, Refresh_Cycle_No);                

                List<string> files = new List<string>();

                if (!String.IsNullOrEmpty(ExcelName))
                {
                    ExcelName = ConfigurationManager.AppSettings["UploadFilePath"] + ExcelName;
                    files.Add(ExcelName);
                }
                if (!String.IsNullOrEmpty(ExcelNameShow))
                {
                    ExcelNameShow = ConfigurationManager.AppSettings["UploadFilePath"] + ExcelNameShow;
                    files.Add(ExcelNameShow);
                }
                if (!String.IsNullOrEmpty(PDFName))
                {
                    PDFName = ConfigurationManager.AppSettings["UploadFilePath"] + PDFName;
                    files.Add(PDFName);
                }

                ZipFileName = CreateZipFile(Destination, files);

                if (!String.IsNullOrEmpty(ZipFileName))
                {
                    ZipFileName = ProposalID + " (CY-" + Refresh_Cycle_No + ")" + ".zip";
                    objUSPAL_UpdateAL_RecommendationRepositories.USPAL_UpdateAL_Recommendation(AL_Recommendation_Code, ZipFileName);
                }
            }
            
        }
        public static string ExportToExcelByRecommendation(int AL_Recommendation_Code, int AL_Proposal_Code, int Refresh_Cycle_No)
        {
            string ExcelSheetName = "";
            USPAL_List_Status_HistoryRepositories objUSPAL_List_Status_HistoryRepositories = new USPAL_List_Status_HistoryRepositories();
            USPAL_RecommendationExportToExcel_ShowRepositories objUSPAL_RecommendationExportToExcel_ShowRepositories = new USPAL_RecommendationExportToExcel_ShowRepositories();
            GetRecommendationRulesRepositories objGetRecommendationRulesRepositories = new GetRecommendationRulesRepositories();
            AL_RecommendationRepositories objAL_RecommendationRepositories = new AL_RecommendationRepositories();
            AL_ProposalRepositories objAL_ProposalRepositories = new AL_ProposalRepositories();
            //USPAL_UpdateAL_RecommendationRepositories objUSPAL_UpdateAL_RecommendationRepositories = new USPAL_UpdateAL_RecommendationRepositories();
            ListtoDataTable objListtoDataTable = new ListtoDataTable();

            List<RecommendationRule> lstRecommendationRule = new List<RecommendationRule>();
            lstRecommendationRule = objGetRecommendationRulesRepositories.GetRecommendationRules(AL_Recommendation_Code).ToList();

            string ProposalID = objAL_ProposalRepositories.GetProposal(AL_Proposal_Code).Proposal_No;

            List<USPAL_RecommendationExportToExcel_Movie> lstExportMetadata = new List<USPAL_RecommendationExportToExcel_Movie>();
            List<USPAL_RecommendationExportToExcel_Show> lstExportMetadata_Show = new List<USPAL_RecommendationExportToExcel_Show>();


            string Destination = ConfigurationManager.AppSettings["UploadFilePath"] + ProposalID + " (CY-" + Refresh_Cycle_No + ")-Episodic" + ".xlsx";// + "\\Temp\\AcquisitionReport.xlsx";
            FileInfo OldFile = new FileInfo(ConfigurationManager.AppSettings["UploadFilePath"] + "Sample1.xlsx");
            FileInfo newFile = new FileInfo(Destination);
            string Name = newFile.Name.ToString();
            if (newFile.Exists)
            {
                newFile.Delete(); // ensures we create a new workbook
                newFile = new FileInfo(Destination);
            }

            var excelPackage = new ExcelPackage(newFile, OldFile);
            //var sheet = excelPackage.Workbook.Worksheets["Sheet1"];

            foreach (var RecommendationRule in lstRecommendationRule)
            {
                ExcelWorksheet sheet_Movie = excelPackage.Workbook.Worksheets.Add("" + RecommendationRule.Rule_Name + "");
                // sheet_Movie.Name = "Metadata";
                if (RecommendationRule.Rule_Type == "M")
                {
                    lstExportMetadata = objUSPAL_List_Status_HistoryRepositories.GetRecommendationData(AL_Recommendation_Code, RecommendationRule.AL_Vendor_Rule_Code).ToList();

                    sheet_Movie.Cells[1, 1].Value = "Title";
                    sheet_Movie.Cells[1, 2].Value = "ARD";
                    sheet_Movie.Cells[1, 3].Value = "Theatrical Release Date";
                    sheet_Movie.Cells[1, 4].Value = "MPAA Rating";
                    sheet_Movie.Cells[1, 5].Value = "Genre";
                    sheet_Movie.Cells[1, 6].Value = "Studio";
                    sheet_Movie.Cells[1, 7].Value = "Version";
                    sheet_Movie.Cells[1, 8].Value = "Title Language";
                    sheet_Movie.Cells[1, 9].Value = "Subtitles";
                    sheet_Movie.Cells[1, 10].Value = "Duration(in mins)";
                    sheet_Movie.Cells[1, 11].Value = "Director";
                    sheet_Movie.Cells[1, 12].Value = "Cast";
                    sheet_Movie.Cells[1, 13].Value = "Synopsis";
                    sheet_Movie.Cells[1, 14].Value = "IMDB Rating";
                    sheet_Movie.Cells[1, 15].Value = "IMDB Popularity";
                    sheet_Movie.Cells[1, 16].Value = "IMDB Up/Down";
                    sheet_Movie.Cells[1, 17].Value = "Rotten Tomatoes Rating (Tomatometer)";
                    sheet_Movie.Cells[1, 18].Value = "Rotten Tomatoes Rating (Audience Score)";
                    sheet_Movie.Cells[1, 19].Value = "Rights";
                    sheet_Movie.Cells[1, 20].Value = "Awards";
                    sheet_Movie.Cells[1, 21].Value = "Nominations";
                    sheet_Movie.Cells[1, 22].Value = "Box Office";
                    sheet_Movie.Cells[1, 23].Value = "General Remarks";

                    for (int i = 1; i <= 23; i++)
                    {
                        Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                        sheet_Movie.Cells[1, i].Style.Font.Bold = true;
                        sheet_Movie.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                        sheet_Movie.Cells[1, i].Style.Font.Size = 11;
                        sheet_Movie.Cells[1, i].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        sheet_Movie.Cells[1, i].Style.Fill.BackgroundColor.SetColor(colFromHex);
                        sheet_Movie.Cells[1, i].AutoFitColumns();

                    }

                    ExcelColumn col1 = sheet_Movie.Column(1);
                    ExcelColumn col2 = sheet_Movie.Column(2);
                    ExcelColumn col3 = sheet_Movie.Column(3);
                    ExcelColumn col4 = sheet_Movie.Column(4);
                    ExcelColumn col5 = sheet_Movie.Column(5);
                    ExcelColumn col6 = sheet_Movie.Column(6);
                    ExcelColumn col7 = sheet_Movie.Column(7);
                    ExcelColumn col8 = sheet_Movie.Column(8);
                    ExcelColumn col9 = sheet_Movie.Column(9);
                    ExcelColumn col10 = sheet_Movie.Column(10);
                    ExcelColumn col11 = sheet_Movie.Column(11);
                    ExcelColumn col12 = sheet_Movie.Column(12);
                    ExcelColumn col13 = sheet_Movie.Column(13);
                    ExcelColumn col14 = sheet_Movie.Column(14);
                    ExcelColumn col15 = sheet_Movie.Column(15);
                    ExcelColumn col16 = sheet_Movie.Column(16);
                    ExcelColumn col17 = sheet_Movie.Column(17);
                    ExcelColumn col18 = sheet_Movie.Column(18);
                    ExcelColumn col19 = sheet_Movie.Column(19);
                    ExcelColumn col20 = sheet_Movie.Column(20);
                    ExcelColumn col21 = sheet_Movie.Column(21);
                    ExcelColumn col22 = sheet_Movie.Column(22);
                    ExcelColumn col23 = sheet_Movie.Column(23);

                    col1.Width = 22;
                    col2.Width = 18;
                    col3.Width = 40;
                    col4.Width = 20;
                    col5.Width = 18;
                    col6.Width = 15;
                    col7.Width = 15;
                    col8.Width = 15;
                    col9.Width = 15;
                    col10.Width = 15;
                    col11.Width = 15;
                    col12.Width = 15;
                    col13.Width = 15;
                    col14.Width = 15;
                    col15.Width = 15;
                    col16.Width = 15;
                    col17.Width = 15;
                    col18.Width = 15;
                    col19.Width = 15;
                    col20.Width = 15;
                    col21.Width = 15;
                    col22.Width = 15;
                    col23.Width = 15;


                    for (int i = 0; i < lstExportMetadata.Count; i++)
                    {
                        DateTime dt = DateTime.Now;
                        string RequestedDate = dt.ToString("dd-MMM-yyyy");

                        sheet_Movie.Cells["A" + (i + 2)].Value = lstExportMetadata[i].Title_Name.ToString();
                        sheet_Movie.Cells["B" + (i + 2)].Value = lstExportMetadata[i].ARD.ToString();
                        sheet_Movie.Cells["C" + (i + 2)].Value = lstExportMetadata[i].TheatricalRelease.ToString();
                        sheet_Movie.Cells["D" + (i + 2)].Value = lstExportMetadata[i].MPAARating.ToString();
                        sheet_Movie.Cells["E" + (i + 2)].Value = lstExportMetadata[i].Genre.ToString();
                        sheet_Movie.Cells["F" + (i + 2)].Value = lstExportMetadata[i].Studio.ToString();
                        sheet_Movie.Cells["G" + (i + 2)].Value = lstExportMetadata[i].Version.ToString();
                        sheet_Movie.Cells["H" + (i + 2)].Value = lstExportMetadata[i].Title_Language.ToString();
                        sheet_Movie.Cells["I" + (i + 2)].Value = lstExportMetadata[i].Subtitles.ToString();
                        sheet_Movie.Cells["J" + (i + 2)].Value = lstExportMetadata[i].Duration.ToString();
                        sheet_Movie.Cells["K" + (i + 2)].Value = lstExportMetadata[i].Director.ToString();
                        sheet_Movie.Cells["L" + (i + 2)].Value = lstExportMetadata[i].Cast.ToString();
                        sheet_Movie.Cells["M" + (i + 2)].Value = lstExportMetadata[i].Synopsis.ToString();
                        sheet_Movie.Cells["N" + (i + 2)].Value = lstExportMetadata[i].IMDB_Rating.ToString();
                        sheet_Movie.Cells["O" + (i + 2)].Value = lstExportMetadata[i].IMDB_Popularity.ToString();
                        sheet_Movie.Cells["P" + (i + 2)].Value = lstExportMetadata[i].IMDB_UpDown.ToString();
                        sheet_Movie.Cells["Q" + (i + 2)].Value = lstExportMetadata[i].RottenTomatoes_Tamotmeter.ToString();
                        sheet_Movie.Cells["R" + (i + 2)].Value = lstExportMetadata[i].RottenTomatoes_Rating.ToString();
                        sheet_Movie.Cells["S" + (i + 2)].Value = lstExportMetadata[i].Rights.ToString();
                        sheet_Movie.Cells["T" + (i + 2)].Value = lstExportMetadata[i].Awards.ToString();
                        sheet_Movie.Cells["U" + (i + 2)].Value = lstExportMetadata[i].Nominations.ToString();
                        sheet_Movie.Cells["V" + (i + 2)].Value = lstExportMetadata[i].BoxOffice.ToString();
                        sheet_Movie.Cells["W" + (i + 2)].Value = lstExportMetadata[i].GeneralRemarks.ToString();



                        sheet_Movie.Cells["A" + (i + 2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["A" + (i + 2)].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);

                        if (lstExportMetadata[i].Content_Type == "H" && lstExportMetadata[i].Content_Status == "D")
                        {
                            for (int j = 1; j <= 23; j++)
                            {
                                Color colFromHex_Delete = System.Drawing.ColorTranslator.FromHtml("#f54e4e");
                                sheet_Movie.Cells[i + 2, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                sheet_Movie.Cells[i + 2, j].Style.Fill.BackgroundColor.SetColor(colFromHex_Delete);
                            }

                        }

                        sheet_Movie.Cells["A" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["B" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["C" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["D" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["E" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["F" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["G" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["H" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["I" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["J" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["K" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["L" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["M" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["N" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["O" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["P" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["Q" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["R" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["S" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["T" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["U" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["V" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["W" + (i + 2)].Style.Font.Name = "Calibri";

                        sheet_Movie.Cells["F" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["G" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["H" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    }
                }
                else
                {
                    lstExportMetadata_Show = objUSPAL_RecommendationExportToExcel_ShowRepositories.GetRecommendationData_Show(AL_Recommendation_Code, RecommendationRule.AL_Vendor_Rule_Code,"").ToList();

                    sheet_Movie.Cells[1, 1].Value = "Titles";
                    sheet_Movie.Cells[1, 2].Value = "Year of Release";
                    sheet_Movie.Cells[1, 3].Value = "MPAA RAting";
                    sheet_Movie.Cells[1, 4].Value = "Genre";
                    sheet_Movie.Cells[1, 5].Value = "Studio";
                    sheet_Movie.Cells[1, 6].Value = "Season";
                    sheet_Movie.Cells[1, 7].Value = "Total Episodes";
                    sheet_Movie.Cells[1, 8].Value = "Episode Name";
                    sheet_Movie.Cells[1, 9].Value = "Episode Number";
                    sheet_Movie.Cells[1, 10].Value = "Episode Duration";
                    sheet_Movie.Cells[1, 11].Value = "Episode Synopsis";
                    sheet_Movie.Cells[1, 12].Value = "Synopsis";
                    sheet_Movie.Cells[1, 13].Value = "Title Language";
                    sheet_Movie.Cells[1, 14].Value = "Subtitles";
                    sheet_Movie.Cells[1, 15].Value = "Duration(in min)";
                    sheet_Movie.Cells[1, 16].Value = "Director";
                    sheet_Movie.Cells[1, 17].Value = "Cast";
                    sheet_Movie.Cells[1, 18].Value = "IMDB Rating";
                    sheet_Movie.Cells[1, 19].Value = "General Remarks";

                    for (int i = 1; i <= 20; i++)
                    {
                        Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                        sheet_Movie.Cells[1, i].Style.Font.Bold = true;
                        sheet_Movie.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                        sheet_Movie.Cells[1, i].Style.Font.Size = 11;
                        sheet_Movie.Cells[1, i].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        sheet_Movie.Cells[1, i].Style.Fill.BackgroundColor.SetColor(colFromHex);
                        sheet_Movie.Cells[1, i].AutoFitColumns();

                    }

                    ExcelColumn col1 = sheet_Movie.Column(1);
                    ExcelColumn col2 = sheet_Movie.Column(2);
                    ExcelColumn col3 = sheet_Movie.Column(3);
                    ExcelColumn col4 = sheet_Movie.Column(4);
                    ExcelColumn col5 = sheet_Movie.Column(5);
                    ExcelColumn col6 = sheet_Movie.Column(6);
                    ExcelColumn col7 = sheet_Movie.Column(7);
                    ExcelColumn col8 = sheet_Movie.Column(8);
                    ExcelColumn col9 = sheet_Movie.Column(9);
                    ExcelColumn col10 = sheet_Movie.Column(10);
                    ExcelColumn col11 = sheet_Movie.Column(11);
                    ExcelColumn col12 = sheet_Movie.Column(12);
                    ExcelColumn col13 = sheet_Movie.Column(13);
                    ExcelColumn col14 = sheet_Movie.Column(14);
                    ExcelColumn col15 = sheet_Movie.Column(15);
                    ExcelColumn col16 = sheet_Movie.Column(16);
                    ExcelColumn col17 = sheet_Movie.Column(17);
                    ExcelColumn col18 = sheet_Movie.Column(18);
                    ExcelColumn col19 = sheet_Movie.Column(19);
                    ExcelColumn col20 = sheet_Movie.Column(20);

                    col1.Width = 22;
                    col2.Width = 18;
                    col3.Width = 40;
                    col4.Width = 20;
                    col5.Width = 18;
                    col6.Width = 15;
                    col7.Width = 15;
                    col8.Width = 15;
                    col9.Width = 15;
                    col10.Width = 15;
                    col11.Width = 15;
                    col12.Width = 15;
                    col13.Width = 15;
                    col14.Width = 15;
                    col15.Width = 15;
                    col16.Width = 15;
                    col17.Width = 15;
                    col18.Width = 15;
                    col19.Width = 15;
                    col20.Width = 15;

                    for (int i = 0; i < lstExportMetadata_Show.Count; i++)
                    {
                        DateTime dt = DateTime.Now;
                        string RequestedDate = dt.ToString("dd-MMM-yyyy");

                        sheet_Movie.Cells["A" + (i + 2)].Value = lstExportMetadata_Show[i].Title_Name.ToString();
                        sheet_Movie.Cells["B" + (i + 2)].Value = lstExportMetadata_Show[i].YOR.ToString();
                        sheet_Movie.Cells["C" + (i + 2)].Value = lstExportMetadata_Show[i].MPAARating.ToString();
                        sheet_Movie.Cells["D" + (i + 2)].Value = lstExportMetadata_Show[i].Genre.ToString();
                        sheet_Movie.Cells["E" + (i + 2)].Value = lstExportMetadata_Show[i].Studio.ToString();
                        sheet_Movie.Cells["F" + (i + 2)].Value = lstExportMetadata_Show[i].Season.ToString();
                        sheet_Movie.Cells["G" + (i + 2)].Value = lstExportMetadata_Show[i].TotalNumberOfEpisodes.ToString();
                        sheet_Movie.Cells["H" + (i + 2)].Value = lstExportMetadata_Show[i].Episode_Name.ToString();
                        sheet_Movie.Cells["I" + (i + 2)].Value = lstExportMetadata_Show[i].Episode_Number.ToString();
                        sheet_Movie.Cells["J" + (i + 2)].Value = lstExportMetadata_Show[i].Episode_Duration.ToString();
                        sheet_Movie.Cells["K" + (i + 2)].Value = lstExportMetadata_Show[i].Episode_Synopsis.ToString();
                        sheet_Movie.Cells["L" + (i + 2)].Value = lstExportMetadata_Show[i].Synopsis.ToString();
                        sheet_Movie.Cells["M" + (i + 2)].Value = lstExportMetadata_Show[i].Title_Language.ToString();
                        sheet_Movie.Cells["N" + (i + 2)].Value = lstExportMetadata_Show[i].Subtitles.ToString();
                        sheet_Movie.Cells["O" + (i + 2)].Value = lstExportMetadata_Show[i].Duration.ToString();
                        sheet_Movie.Cells["P" + (i + 2)].Value = lstExportMetadata_Show[i].Director.ToString();
                        sheet_Movie.Cells["Q" + (i + 2)].Value = lstExportMetadata_Show[i].Cast.ToString();
                        sheet_Movie.Cells["R" + (i + 2)].Value = lstExportMetadata_Show[i].IMDB_Rating.ToString();
                        sheet_Movie.Cells["S" + (i + 2)].Value = lstExportMetadata_Show[i].GeneralRemarks.ToString();

                        sheet_Movie.Cells["A" + (i + 2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["A" + (i + 2)].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);

                        if (lstExportMetadata_Show[i].Content_Type == "H" && lstExportMetadata_Show[i].Content_Status == "D")
                        {
                            for (int j = 1; j <= 20; j++)
                            {
                                Color colFromHex_Delete = System.Drawing.ColorTranslator.FromHtml("#f54e4e");
                                sheet_Movie.Cells[i + 2, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                sheet_Movie.Cells[i + 2, j].Style.Fill.BackgroundColor.SetColor(colFromHex_Delete);
                            }

                        }

                        sheet_Movie.Cells["A" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["B" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["C" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["D" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["E" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["F" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["G" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["H" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["I" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["J" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["K" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["L" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["M" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["N" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["O" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["P" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["Q" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["R" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["S" + (i + 2)].Style.Font.Name = "Calibri";


                        sheet_Movie.Cells["F" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["G" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["H" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    }
                }

            }

            //objUSPAL_UpdateAL_RecommendationRepositories.USPAL_UpdateAL_Recommendation(AL_Recommendation_Code, newFile.Name);
            ExcelSheetName = newFile.Name;
            var workbookFileInfo = new FileInfo(@"" + newFile.Name + "");

            excelPackage.Workbook.Properties.Title = "PlanIT";
            excelPackage.Workbook.Properties.Author = "";
            excelPackage.Workbook.Properties.Comments = "";

            // set some extended property values
            excelPackage.Workbook.Properties.Company = "";

            // set some custom property values
            excelPackage.Workbook.Properties.SetCustomPropertyValue("Checked by", "");
            excelPackage.Workbook.Properties.SetCustomPropertyValue("AssemblyName", "EPPlus");

            var worksheet = excelPackage.Workbook.Worksheets.SingleOrDefault(x => x.Name == "Sheet1");
            excelPackage.Workbook.Worksheets.Delete(worksheet);
            // save our new workbook and we are done!
            excelPackage.Save();

            return ExcelSheetName;

        }
        public static string ExportToExcelByRecommendationShow(int AL_Recommendation_Code, int AL_Proposal_Code, int Refresh_Cycle_No)
        {
            string ExcelSheetName = "";
            USPAL_List_Status_HistoryRepositories objUSPAL_List_Status_HistoryRepositories = new USPAL_List_Status_HistoryRepositories();
            USPAL_RecommendationExportToExcel_ShowRepositories objUSPAL_RecommendationExportToExcel_ShowRepositories = new USPAL_RecommendationExportToExcel_ShowRepositories();
            GetRecommendationRulesRepositories objGetRecommendationRulesRepositories = new GetRecommendationRulesRepositories();
            AL_RecommendationRepositories objAL_RecommendationRepositories = new AL_RecommendationRepositories();
            AL_ProposalRepositories objAL_ProposalRepositories = new AL_ProposalRepositories();
            //USPAL_UpdateAL_RecommendationRepositories objUSPAL_UpdateAL_RecommendationRepositories = new USPAL_UpdateAL_RecommendationRepositories();
            ListtoDataTable objListtoDataTable = new ListtoDataTable();

            List<RecommendationRule> lstRecommendationRule = new List<RecommendationRule>();
            lstRecommendationRule = objGetRecommendationRulesRepositories.GetRecommendationRules(AL_Recommendation_Code).ToList();

            string ProposalID = objAL_ProposalRepositories.GetProposal(AL_Proposal_Code).Proposal_No;

            List<USPAL_RecommendationExportToExcel_Movie> lstExportMetadata = new List<USPAL_RecommendationExportToExcel_Movie>();
            List<USPAL_RecommendationExportToExcel_Show> lstExportMetadata_Show = new List<USPAL_RecommendationExportToExcel_Show>();


            string Destination = ConfigurationManager.AppSettings["UploadFilePath"] + ProposalID + " (CY-" + Refresh_Cycle_No + ")-Show" + ".xlsx";// + "\\Temp\\AcquisitionReport.xlsx";
            FileInfo OldFile = new FileInfo(ConfigurationManager.AppSettings["UploadFilePath"] + "Sample1.xlsx");
            FileInfo newFile = new FileInfo(Destination);
            string Name = newFile.Name.ToString();
            if (newFile.Exists)
            {
                newFile.Delete(); // ensures we create a new workbook
                newFile = new FileInfo(Destination);
            }

            var excelPackage = new ExcelPackage(newFile, OldFile);
            //var sheet = excelPackage.Workbook.Worksheets["Sheet1"];

            foreach (var RecommendationRule in lstRecommendationRule)
            {
                ExcelWorksheet sheet_Movie = excelPackage.Workbook.Worksheets.Add("" + RecommendationRule.Rule_Name + "");
                // sheet_Movie.Name = "Metadata";
                if (RecommendationRule.Rule_Type == "M")
                {
                    lstExportMetadata = objUSPAL_List_Status_HistoryRepositories.GetRecommendationData(AL_Recommendation_Code, RecommendationRule.AL_Vendor_Rule_Code).ToList();

                    sheet_Movie.Cells[1, 1].Value = "Title";
                    sheet_Movie.Cells[1, 2].Value = "ARD";
                    sheet_Movie.Cells[1, 3].Value = "Theatrical Release Date";
                    sheet_Movie.Cells[1, 4].Value = "MPAA Rating";
                    sheet_Movie.Cells[1, 5].Value = "Genre";
                    sheet_Movie.Cells[1, 6].Value = "Studio";
                    sheet_Movie.Cells[1, 7].Value = "Version";
                    sheet_Movie.Cells[1, 8].Value = "Title Language";
                    sheet_Movie.Cells[1, 9].Value = "Subtitles";
                    sheet_Movie.Cells[1, 10].Value = "Duration(in mins)";
                    sheet_Movie.Cells[1, 11].Value = "Director";
                    sheet_Movie.Cells[1, 12].Value = "Cast";
                    sheet_Movie.Cells[1, 13].Value = "Synopsis";
                    sheet_Movie.Cells[1, 14].Value = "IMDB Rating";
                    sheet_Movie.Cells[1, 15].Value = "IMDB Popularity";
                    sheet_Movie.Cells[1, 16].Value = "IMDB Up/Down";
                    sheet_Movie.Cells[1, 17].Value = "Rotten Tomatoes Rating (Tomatometer)";
                    sheet_Movie.Cells[1, 18].Value = "Rotten Tomatoes Rating (Audience Score)";
                    sheet_Movie.Cells[1, 19].Value = "Rights";
                    sheet_Movie.Cells[1, 20].Value = "Awards";
                    sheet_Movie.Cells[1, 21].Value = "Nominations";
                    sheet_Movie.Cells[1, 22].Value = "Box Office";
                    sheet_Movie.Cells[1, 23].Value = "General Remarks";

                    for (int i = 1; i <= 23; i++)
                    {
                        Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                        sheet_Movie.Cells[1, i].Style.Font.Bold = true;
                        sheet_Movie.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                        sheet_Movie.Cells[1, i].Style.Font.Size = 11;
                        sheet_Movie.Cells[1, i].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        sheet_Movie.Cells[1, i].Style.Fill.BackgroundColor.SetColor(colFromHex);
                        sheet_Movie.Cells[1, i].AutoFitColumns();

                    }

                    ExcelColumn col1 = sheet_Movie.Column(1);
                    ExcelColumn col2 = sheet_Movie.Column(2);
                    ExcelColumn col3 = sheet_Movie.Column(3);
                    ExcelColumn col4 = sheet_Movie.Column(4);
                    ExcelColumn col5 = sheet_Movie.Column(5);
                    ExcelColumn col6 = sheet_Movie.Column(6);
                    ExcelColumn col7 = sheet_Movie.Column(7);
                    ExcelColumn col8 = sheet_Movie.Column(8);
                    ExcelColumn col9 = sheet_Movie.Column(9);
                    ExcelColumn col10 = sheet_Movie.Column(10);
                    ExcelColumn col11 = sheet_Movie.Column(11);
                    ExcelColumn col12 = sheet_Movie.Column(12);
                    ExcelColumn col13 = sheet_Movie.Column(13);
                    ExcelColumn col14 = sheet_Movie.Column(14);
                    ExcelColumn col15 = sheet_Movie.Column(15);
                    ExcelColumn col16 = sheet_Movie.Column(16);
                    ExcelColumn col17 = sheet_Movie.Column(17);
                    ExcelColumn col18 = sheet_Movie.Column(18);
                    ExcelColumn col19 = sheet_Movie.Column(19);
                    ExcelColumn col20 = sheet_Movie.Column(20);
                    ExcelColumn col21 = sheet_Movie.Column(21);
                    ExcelColumn col22 = sheet_Movie.Column(22);
                    ExcelColumn col23 = sheet_Movie.Column(23);

                    col1.Width = 22;
                    col2.Width = 18;
                    col3.Width = 40;
                    col4.Width = 20;
                    col5.Width = 18;
                    col6.Width = 15;
                    col7.Width = 15;
                    col8.Width = 15;
                    col9.Width = 15;
                    col10.Width = 15;
                    col11.Width = 15;
                    col12.Width = 15;
                    col13.Width = 15;
                    col14.Width = 15;
                    col15.Width = 15;
                    col16.Width = 15;
                    col17.Width = 15;
                    col18.Width = 15;
                    col19.Width = 15;
                    col20.Width = 15;
                    col21.Width = 15;
                    col22.Width = 15;
                    col23.Width = 15;


                    for (int i = 0; i < lstExportMetadata.Count; i++)
                    {
                        DateTime dt = DateTime.Now;
                        string RequestedDate = dt.ToString("dd-MMM-yyyy");

                        sheet_Movie.Cells["A" + (i + 2)].Value = lstExportMetadata[i].Title_Name.ToString();
                        sheet_Movie.Cells["B" + (i + 2)].Value = lstExportMetadata[i].ARD.ToString();
                        sheet_Movie.Cells["C" + (i + 2)].Value = lstExportMetadata[i].TheatricalRelease.ToString();
                        sheet_Movie.Cells["D" + (i + 2)].Value = lstExportMetadata[i].MPAARating.ToString();
                        sheet_Movie.Cells["E" + (i + 2)].Value = lstExportMetadata[i].Genre.ToString();
                        sheet_Movie.Cells["F" + (i + 2)].Value = lstExportMetadata[i].Studio.ToString();
                        sheet_Movie.Cells["G" + (i + 2)].Value = lstExportMetadata[i].Version.ToString();
                        sheet_Movie.Cells["H" + (i + 2)].Value = lstExportMetadata[i].Title_Language.ToString();
                        sheet_Movie.Cells["I" + (i + 2)].Value = lstExportMetadata[i].Subtitles.ToString();
                        sheet_Movie.Cells["J" + (i + 2)].Value = lstExportMetadata[i].Duration.ToString();
                        sheet_Movie.Cells["K" + (i + 2)].Value = lstExportMetadata[i].Director.ToString();
                        sheet_Movie.Cells["L" + (i + 2)].Value = lstExportMetadata[i].Cast.ToString();
                        sheet_Movie.Cells["M" + (i + 2)].Value = lstExportMetadata[i].Synopsis.ToString();
                        sheet_Movie.Cells["N" + (i + 2)].Value = lstExportMetadata[i].IMDB_Rating.ToString();
                        sheet_Movie.Cells["O" + (i + 2)].Value = lstExportMetadata[i].IMDB_Popularity.ToString();
                        sheet_Movie.Cells["P" + (i + 2)].Value = lstExportMetadata[i].IMDB_UpDown.ToString();
                        sheet_Movie.Cells["Q" + (i + 2)].Value = lstExportMetadata[i].RottenTomatoes_Tamotmeter.ToString();
                        sheet_Movie.Cells["R" + (i + 2)].Value = lstExportMetadata[i].RottenTomatoes_Rating.ToString();
                        sheet_Movie.Cells["S" + (i + 2)].Value = lstExportMetadata[i].Rights.ToString();
                        sheet_Movie.Cells["T" + (i + 2)].Value = lstExportMetadata[i].Awards.ToString();
                        sheet_Movie.Cells["U" + (i + 2)].Value = lstExportMetadata[i].Nominations.ToString();
                        sheet_Movie.Cells["V" + (i + 2)].Value = lstExportMetadata[i].BoxOffice.ToString();
                        sheet_Movie.Cells["W" + (i + 2)].Value = lstExportMetadata[i].GeneralRemarks.ToString();



                        sheet_Movie.Cells["A" + (i + 2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["A" + (i + 2)].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);

                        if (lstExportMetadata[i].Content_Type == "H" && lstExportMetadata[i].Content_Status == "D")
                        {
                            for (int j = 1; j <= 23; j++)
                            {
                                Color colFromHex_Delete = System.Drawing.ColorTranslator.FromHtml("#f54e4e");
                                sheet_Movie.Cells[i + 2, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                sheet_Movie.Cells[i + 2, j].Style.Fill.BackgroundColor.SetColor(colFromHex_Delete);
                            }

                        }

                        sheet_Movie.Cells["A" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["B" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["C" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["D" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["E" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["F" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["G" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["H" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["I" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["J" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["K" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["L" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["M" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["N" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["O" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["P" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["Q" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["R" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["S" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["T" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["U" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["V" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["W" + (i + 2)].Style.Font.Name = "Calibri";

                        sheet_Movie.Cells["F" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["G" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["H" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    }
                }
                else
                {
                    lstExportMetadata_Show = objUSPAL_RecommendationExportToExcel_ShowRepositories.GetRecommendationData_Show(AL_Recommendation_Code, RecommendationRule.AL_Vendor_Rule_Code,"GRP").ToList();

                    sheet_Movie.Cells[1, 1].Value = "Titles";
                    sheet_Movie.Cells[1, 2].Value = "Year of Release";
                    sheet_Movie.Cells[1, 3].Value = "MPAA RAting";
                    sheet_Movie.Cells[1, 4].Value = "Genre";
                    sheet_Movie.Cells[1, 5].Value = "Studio";
                    sheet_Movie.Cells[1, 6].Value = "Season";
                    sheet_Movie.Cells[1, 7].Value = "No. of Episodes";
                    sheet_Movie.Cells[1, 8].Value = "Total Episodes";
                    sheet_Movie.Cells[1, 9].Value = "Synopsis";
                    sheet_Movie.Cells[1, 10].Value = "Title Language";
                    sheet_Movie.Cells[1, 11].Value = "Subtitles";
                    sheet_Movie.Cells[1, 12].Value = "Duration(in min)";
                    sheet_Movie.Cells[1, 13].Value = "Director";
                    sheet_Movie.Cells[1, 14].Value = "Cast";
                    sheet_Movie.Cells[1, 15].Value = "IMDB Rating";
                    sheet_Movie.Cells[1, 16].Value = "General Remarks";

                    for (int i = 1; i <= 17; i++)
                    {
                        Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                        sheet_Movie.Cells[1, i].Style.Font.Bold = true;
                        sheet_Movie.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                        sheet_Movie.Cells[1, i].Style.Font.Size = 11;
                        sheet_Movie.Cells[1, i].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        sheet_Movie.Cells[1, i].Style.Fill.BackgroundColor.SetColor(colFromHex);
                        sheet_Movie.Cells[1, i].AutoFitColumns();

                    }

                    ExcelColumn col1 = sheet_Movie.Column(1);
                    ExcelColumn col2 = sheet_Movie.Column(2);
                    ExcelColumn col3 = sheet_Movie.Column(3);
                    ExcelColumn col4 = sheet_Movie.Column(4);
                    ExcelColumn col5 = sheet_Movie.Column(5);
                    ExcelColumn col6 = sheet_Movie.Column(6);
                    ExcelColumn col7 = sheet_Movie.Column(7);
                    ExcelColumn col8 = sheet_Movie.Column(8);
                    ExcelColumn col9 = sheet_Movie.Column(9);
                    ExcelColumn col10 = sheet_Movie.Column(10);
                    ExcelColumn col11 = sheet_Movie.Column(11);
                    ExcelColumn col12 = sheet_Movie.Column(12);
                    ExcelColumn col13 = sheet_Movie.Column(13);
                    ExcelColumn col14 = sheet_Movie.Column(14);
                    ExcelColumn col15 = sheet_Movie.Column(15);
                    ExcelColumn col16 = sheet_Movie.Column(16);
                    ExcelColumn col17 = sheet_Movie.Column(17);

                    col1.Width = 22;
                    col2.Width = 18;
                    col3.Width = 40;
                    col4.Width = 20;
                    col5.Width = 18;
                    col6.Width = 15;
                    col7.Width = 15;
                    col8.Width = 15;
                    col9.Width = 15;
                    col10.Width = 15;
                    col11.Width = 15;
                    col12.Width = 15;
                    col13.Width = 15;
                    col14.Width = 15;
                    col15.Width = 15;
                    col16.Width = 15;
                    col17.Width = 15;

                    for (int i = 0; i < lstExportMetadata_Show.Count; i++)
                    {
                        DateTime dt = DateTime.Now;
                        string RequestedDate = dt.ToString("dd-MMM-yyyy");

                        sheet_Movie.Cells["A" + (i + 2)].Value = lstExportMetadata_Show[i].Title_Name.ToString();
                        sheet_Movie.Cells["B" + (i + 2)].Value = lstExportMetadata_Show[i].YOR.ToString();
                        sheet_Movie.Cells["C" + (i + 2)].Value = lstExportMetadata_Show[i].MPAARating.ToString();
                        sheet_Movie.Cells["D" + (i + 2)].Value = lstExportMetadata_Show[i].Genre.ToString();
                        sheet_Movie.Cells["E" + (i + 2)].Value = lstExportMetadata_Show[i].Studio.ToString();
                        sheet_Movie.Cells["F" + (i + 2)].Value = lstExportMetadata_Show[i].Season.ToString();
                        sheet_Movie.Cells["G" + (i + 2)].Value = lstExportMetadata_Show[i].NumberOfEpisodes.ToString();
                        sheet_Movie.Cells["H" + (i + 2)].Value = lstExportMetadata_Show[i].TotalNumberOfEpisodes.ToString();
                        sheet_Movie.Cells["I" + (i + 2)].Value = lstExportMetadata_Show[i].Synopsis.ToString();
                        sheet_Movie.Cells["J" + (i + 2)].Value = lstExportMetadata_Show[i].Title_Language.ToString();
                        sheet_Movie.Cells["K" + (i + 2)].Value = lstExportMetadata_Show[i].Subtitles.ToString();
                        sheet_Movie.Cells["L" + (i + 2)].Value = lstExportMetadata_Show[i].Duration.ToString();
                        sheet_Movie.Cells["M" + (i + 2)].Value = lstExportMetadata_Show[i].Director.ToString();
                        sheet_Movie.Cells["N" + (i + 2)].Value = lstExportMetadata_Show[i].Cast.ToString();
                        sheet_Movie.Cells["O" + (i + 2)].Value = lstExportMetadata_Show[i].IMDB_Rating.ToString();
                        sheet_Movie.Cells["P" + (i + 2)].Value = lstExportMetadata_Show[i].GeneralRemarks.ToString();

                        sheet_Movie.Cells["A" + (i + 2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["A" + (i + 2)].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);

                        if (lstExportMetadata_Show[i].Content_Type == "H" && lstExportMetadata_Show[i].Content_Status == "D")
                        {
                            for (int j = 1; j <= 17; j++)
                            {
                                Color colFromHex_Delete = System.Drawing.ColorTranslator.FromHtml("#f54e4e");
                                sheet_Movie.Cells[i + 2, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                sheet_Movie.Cells[i + 2, j].Style.Fill.BackgroundColor.SetColor(colFromHex_Delete);
                            }

                        }

                        sheet_Movie.Cells["A" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["B" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["C" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["D" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["E" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["F" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["G" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["H" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["I" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["J" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["K" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["L" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["M" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["N" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["O" + (i + 2)].Style.Font.Name = "Calibri";
                        sheet_Movie.Cells["P" + (i + 2)].Style.Font.Name = "Calibri";

                        sheet_Movie.Cells["F" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["G" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet_Movie.Cells["H" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    }
                }

            }

            //objUSPAL_UpdateAL_RecommendationRepositories.USPAL_UpdateAL_Recommendation(AL_Recommendation_Code, newFile.Name);
            ExcelSheetName = newFile.Name;
            var workbookFileInfo = new FileInfo(@"" + newFile.Name + "");

            excelPackage.Workbook.Properties.Title = "PlanIT";
            excelPackage.Workbook.Properties.Author = "";
            excelPackage.Workbook.Properties.Comments = "";

            // set some extended property values
            excelPackage.Workbook.Properties.Company = "";

            // set some custom property values
            excelPackage.Workbook.Properties.SetCustomPropertyValue("Checked by", "");
            excelPackage.Workbook.Properties.SetCustomPropertyValue("AssemblyName", "EPPlus");

            var worksheet = excelPackage.Workbook.Worksheets.SingleOrDefault(x => x.Name == "Sheet1");
            excelPackage.Workbook.Worksheets.Delete(worksheet);
            // save our new workbook and we are done!
            excelPackage.Save();

            return ExcelSheetName;

        }
        public static string GenerateRecomPDFTitlewise(int AL_Recommendation_Code, string ProposalID, int Refresh_Cycle_No)
        {
            string PDFName = "";
            ReportExecutionService rs = new ReportExecutionService();
            ReportingCredentials objRC = ReportCredential();

            rs.Credentials = new NetworkCredential(objRC.CredentialdomainName + "\\" + objRC.CredentialUser, objRC.CredentialPassWord);
            string asmxPath = ConfigurationManager.AppSettings["asmxPath"];
            rs.Url = objRC.ReportingServer + "/" + asmxPath;

            rs.ExecutionHeaderValue = new ExecutionHeader();
            var executionInfo = new ExecutionInfo();
            string rdlALRecomPDFConversion = ConfigurationManager.AppSettings["rdlALRecomPDFConversion"];
            //rs.UseDefaultCredentials = true;
            executionInfo = rs.LoadReport(rdlALRecomPDFConversion, null);

            List<ParameterValue> parameters = new List<ParameterValue>();
            parameters.Add(new ParameterValue { Name = "AL_Recommendation_Code", Value = Convert.ToString(AL_Recommendation_Code) });
            rs.SetExecutionParameters(parameters.ToArray(), "en-US");

            string deviceInfo = "<DeviceInfo><Toolbar>False</Toolbar></DeviceInfo>";
            string mimeType;
            string encoding;

            string[] streamId;
            Warning[] warning;

            rs.Timeout = Timeout.Infinite;
            var result = rs.Render("pdf", deviceInfo, out mimeType, out encoding, out encoding, out warning, out streamId);

            string outputFilePath = ConfigurationManager.AppSettings["UploadFilePath"];
            
            string outputFileName =  ProposalID + " (CY-" + Refresh_Cycle_No + ")" + ".pdf"; 

            //Regex reg = new Regex("[*'\",:&#^@]");
            //Title_Name = reg.Replace(Title_Name, "_");
            //outputFileName = PO_Number.Replace("/", "_") + "-" + Title_Name + ".pdf";

            File.WriteAllBytes(outputFilePath + outputFileName, result);
            PDFName = outputFileName;

            return PDFName;
        }
        public static ReportingCredentials ReportCredential()
        {
            ReportingCredentials objRC = new ReportingCredentials();
            var objbufferSize = new
            {
                Parameter_Name = "RPT"
                //IsActive = "Y"
            };
            string strSql = "SELECT Parameter_Name, Parameter_Value FROM System_Parameter_New WHERE Parameter_Name LIKE '%RPT%'";
            DataSet ds = ProcessSelect(strSql);
            DataTable dt = ds.Tables[0];

            foreach (DataRow dr in dt.Rows)
            {
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_ReportingServer")
                    objRC.ReportingServer = Convert.ToString(dr["Parameter_Value"]);
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_IsCredentialRequired")
                    objRC.IsCredentialRequired = Convert.ToString(dr["Parameter_Value"]);
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_CredentialsUserPassWord")
                    objRC.CredentialPassWord = Convert.ToString(dr["Parameter_Value"]);
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_CredentialsUserName")
                    objRC.CredentialUser = Convert.ToString(dr["Parameter_Value"]);
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_CredentialdomainName")
                    objRC.CredentialdomainName = Convert.ToString(dr["Parameter_Value"]);
            }

            return objRC;
        }
        private static DataSet ProcessSelect(string sql)
        {
            //string StrCon = ConfigurationManager.AppSettings["conStr"];
            string StrCon = ConfigurationManager.ConnectionStrings["MusicHubConn"].ConnectionString;
            SqlConnection sqlCon = null;
            SqlDataAdapter da;
            DataSet ds = new DataSet();
            using (sqlCon = new SqlConnection(StrCon))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand(sql, sqlCon);
                sql_cmnd.CommandType = CommandType.Text;
                sql_cmnd.CommandTimeout = 32767;
                da = new SqlDataAdapter(sql_cmnd);
                da.Fill(ds);
            }
            return ds;
        }
        public static string CreateZipFile(string fileName, IEnumerable<string> files)
        {
            string ZipFileName = fileName;

            FileInfo chkZipFile = new FileInfo(fileName);
            if (chkZipFile.Exists)
            {
                chkZipFile.Delete(); // ensures we create a new workbook
                chkZipFile = new FileInfo(fileName);
            }

            var zip = ZipFile.Open(fileName, ZipArchiveMode.Create);
            foreach (var file in files)
            {
                // Add the entry for each file
                zip.CreateEntryFromFile(file, Path.GetFileName(file), System.IO.Compression.CompressionLevel.Optimal);

                FileInfo newFile = new FileInfo(file);
                if (newFile.Exists)
                {
                    newFile.Delete(); // ensures we create a new workbook
                    newFile = new FileInfo(file);
                }
            }
            // Dispose of the object when we are done
            zip.Dispose();
            return ZipFileName;
        }        
    }

    public class ListtoDataTable
    {
        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            //Get all the properties by using reflection   
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names  
                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {

                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }

            return dataTable;
        }
    }
    public class ReportingCredentials
    {
        public string ReportingServer { get; set; }
        public string IsCredentialRequired { get; set; }
        public string CredentialPassWord { get; set; }
        public string CredentialUser { get; set; }
        public string CredentialdomainName { get; set; }
    }

}
