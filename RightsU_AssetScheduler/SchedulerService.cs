using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_AssetScheduler
{
    public partial class ScheduleFileProcess : ServiceBase
    {
        public static string IsAuthKeyRequired = Convert.ToString(ConfigurationSettings.AppSettings["IsAuthKeyRequired"]);
        public static string AuthKey = Convert.ToString(ConfigurationSettings.AppSettings["AuthKey"]);
        public static string AssetPath, RunDefPath, PlayorderPath, SeriesPath;
        public static int AssetBatch, RunDefBatch, SeriesBatch;
        public ScheduleFileProcess()
        {
            InitializeComponent();
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);
        }
        public System.Timers.Timer timer = new System.Timers.Timer();
        protected override void OnStart(string[] args)
        {
            timer.Interval = Convert.ToInt32(ConfigurationSettings.AppSettings["Timer"]);
            timer.Elapsed += new System.Timers.ElapsedEventHandler(this.OnTimer);
            timer.Start();
        }
        protected override void OnStop()
        {
            Error.WriteLog("Service Stoped", includeTime: true, addSeperater: true);
        }
        public void OnTimer(object sender, System.Timers.ElapsedEventArgs args)
        {
            timer.Stop();
            Error.WriteLog("EXE started", includeTime: true, addSeperater: true);
            try
            {
                Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connecting to database");
                using (var context = new RightsU_PlusEntities())
                {
                    Error.WriteLog_Conditional("STEP 1 B : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connected to database");

                    List<SchedulerConfig> lstSchedulerConfigs = context.SchedulerConfigs.ToList();

                    AssetPath = lstSchedulerConfigs.Where(x => x.ModuleName == "AssetPath").Select(x => x.RequestUri).FirstOrDefault();
                    RunDefPath = lstSchedulerConfigs.Where(x => x.ModuleName == "RunDefPath").Select(x => x.RequestUri).FirstOrDefault();
                    PlayorderPath = lstSchedulerConfigs.Where(x => x.ModuleName == "PlayorderPath").Select(x => x.RequestUri).FirstOrDefault();
                    SeriesPath = lstSchedulerConfigs.Where(x => x.ModuleName == "SeriesPath").Select(x => x.RequestUri).FirstOrDefault();

                    AssetBatch = (int)lstSchedulerConfigs.Where(x => x.ModuleName == "AssetPath").Select(x => x.Batch).FirstOrDefault();
                    RunDefBatch = (int)lstSchedulerConfigs.Where(x => x.ModuleName == "RunDefPath").Select(x => x.Batch).FirstOrDefault();
                    SeriesBatch = (int)lstSchedulerConfigs.Where(x => x.ModuleName == "SeriesPath").Select(x => x.Batch).FirstOrDefault();

                    Error.WriteLog_Conditional("STEP 1 C : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Fetched data from SchedulerConfig and assigned all static fields");

                    List<USP_Acq_Assets_Model_Result> lstMovie = context.USP_Acq_Assets_Model("M", 0).ToList();
                    List<USP_Acq_Assets_Model_Result> lstProgram = context.USP_Acq_Assets_Model("P", 0).ToList();
                    List<SchedulerRight> lstAcq_Rights_Model = context.SchedulerRights.Where(x => x.RecordStatus == "P").ToList();

                    #region ---------- Movie ----------
                    int total = lstMovie.Count();
                    int pageSize = AssetBatch;
                    int page = 1;
                    int skip = pageSize * (page - 1);

                    Error.WriteLog_Conditional("STEP 2 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Movie : total = " + total.ToString() + " pageSize =" + pageSize.ToString());

                    while (skip < total)
                    {
                        try
                        {
                            CallAssetsSeries("M", lstMovie.Skip(skip).Take(pageSize).ToList());
                        }
                        catch (Exception ex)
                        {
                            StringBuilder sb = new StringBuilder("Found Exception (MOVIE) : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            while (ex.InnerException != null)
                            {
                                ex = ex.InnerException;
                                sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            }

                            Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
                        }
                        page++;
                        skip = pageSize * (page - 1);
                    }

                    #endregion

                    #region ---------- Program ----------
                    total = lstProgram.Count();
                    pageSize = AssetBatch;
                    page = 1;
                    skip = pageSize * (page - 1);

                    Error.WriteLog_Conditional("STEP 3 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Program : total = " + total.ToString() + " pageSize =" + pageSize.ToString());

                    while (skip < total)
                    {
                        try
                        {
                            CallAssetsSeries("P", lstProgram.Skip(skip).Take(pageSize).ToList());
                        }
                        catch (Exception ex)
                        {
                            StringBuilder sb = new StringBuilder("Found Exception (PROGRAM) : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            while (ex.InnerException != null)
                            {
                                ex = ex.InnerException;
                                sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            }

                            Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
                        }

                        page++;
                        skip = pageSize * (page - 1);
                    }
                    #endregion

                    #region ---------- Series ----------
                    total = lstProgram.Count();
                    pageSize = SeriesBatch;
                    page = 1;
                    skip = pageSize * (page - 1);

                    Error.WriteLog_Conditional("STEP 4 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Series : total = " + total.ToString() + " pageSize =" + pageSize.ToString());

                    while (skip < total)
                    {
                        try
                        {
                            CallAssetsSeries("S", lstProgram.Skip(skip).Take(pageSize).ToList());
                        }
                        catch (Exception ex)
                        {
                            StringBuilder sb = new StringBuilder("Found Exception (SERIES) : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            while (ex.InnerException != null)
                            {
                                ex = ex.InnerException;
                                sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            }

                            Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
                        }
                        page++;
                        skip = pageSize * (page - 1);
                    }
                    #endregion

                    #region ---------- Rights ----------
                    total = lstAcq_Rights_Model.Count();
                    pageSize = SeriesBatch;
                    page = 1;
                    skip = pageSize * (page - 1);

                    Error.WriteLog_Conditional("STEP 5 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Rights : total = " + total.ToString() + " pageSize =" + pageSize.ToString());

                    while (skip < total)
                    {
                        try
                        {
                            CallRights(lstAcq_Rights_Model.Skip(skip).Take(pageSize).ToList());
                        }
                        catch (Exception ex)
                        {
                            int[] arrSchedulerRightId = lstAcq_Rights_Model.Skip(skip).Take(pageSize).ToList().Select(x => x.SchedulerRightId).ToArray();
                            Update_SchedulerRights(arrSchedulerRightId, "E");

                            StringBuilder sb = new StringBuilder("Found Exception (RIGHTS) : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            while (ex.InnerException != null)
                            {
                                ex = ex.InnerException;
                                sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                            }

                            Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
                        }
                        page++;
                        skip = pageSize * (page - 1);
                    }
                    #endregion
                }
            }
            catch (Exception ex)
            {
                StringBuilder sb = new StringBuilder("Found Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                    sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                }

                Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
            }
            finally
            {
                Error.WriteLog("EXE Ended", includeTime: true, addSeperater: true);
                timer.Start();
            }
        }

        #region ------- OTHER METHOD -------------
        public static void CallAssetsSeries(string callFor, List<USP_Acq_Assets_Model_Result> lstAcq_Assets_Model)
        {

            using (var client = new WebClient())
            {
                using (var context = new RightsU_PlusEntities())
                {
                    client.Headers.Clear();
                    client.Headers.Add("Content-Type:application/json");
                    client.Headers.Add("Accept:application/json");
                    if (IsAuthKeyRequired == "Y")
                        client.Headers.Add("Authorization", "Bearer " + AuthKey);
                    if (callFor != "S")
                    {
                        var Acq_Assets_Response = (dynamic)null;
                        if (callFor == "P")
                        {
                            Acq_Assets_Response = lstAcq_Assets_Model.Select(x =>
                               new
                               {
                                   _id = x.C_id.ToString(),
                                   title = x.title,
                                   seasonName = x.seasonName ?? "",
                                   seasonNo = x.seasonNo,
                                   programType = x.programType,
                                   episodeNo = x.episodeNo,
                                   genre = x.genre ?? "",
                                   duration = x.duration,
                                   language = x.language ?? "",
                                   medaiId = x.medaiId,
                                   mediaStatus = x.mediaStatus,
                                   censorship = x.censorship ?? "",
                                   banner = x.banner,
                                   contentType = x.contentType,
                                   subType = x.subType,
                                   trp = x.trp
                               }).ToList();
                        }
                        else if (callFor == "M")
                        {
                            Acq_Assets_Response = lstAcq_Assets_Model.Select(x =>
                               new
                               {
                                   _id = x.C_id.ToString(),
                                   title = x.title,
                                   seasonName = x.seasonName ?? "",
                                   programType = x.programType,
                                   episodeNo = x.episodeNo,
                                   genre = x.genre ?? "",
                                   duration = x.duration,
                                   language = x.language ?? "",
                                   medaiId = x.medaiId,
                                   mediaStatus = x.mediaStatus,
                                   censorship = x.censorship ?? "",
                                   banner = x.banner,
                                   contentType = x.contentType,
                                   subType = x.subType,
                                   trp = x.trp
                               }).ToList();
                        }


                        if (lstAcq_Assets_Model.Count > 0)
                        {
                            Error.WriteLog_Conditional("STEP I CallAssets " + callFor + ": " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " Uploading String : AssetPath = " + AssetPath);

                            Save_Scheduler_Log(AssetPath, "", JsonConvert.SerializeObject(Acq_Assets_Response));
                            var result = client.UploadString(AssetPath, JsonConvert.SerializeObject(Acq_Assets_Response));
                            Save_Scheduler_Log(AssetPath, result);

                            Error.WriteLog_Conditional("STEP II CallAssets " + callFor + ": " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " AssetS Updoaded Successfully ");
                        }
                    }
                    else if (callFor == "S")
                    {
                        List<string> distinctTitleCode = lstAcq_Assets_Model.Select(x => x.Title_Code.ToString()).Distinct().ToList();
                        List<Title> lstTitle = context.Titles.Where(x => distinctTitleCode.Contains(x.Title_Code.ToString())).ToList();
                        var Acq_Series_Response = lstTitle.Select(x => new
                        {
                            _id = "S" + x.Title_Code,
                            title = x.Title_Name,
                            duration = x.Duration_In_Min,
                            contentType = 1,
                            playOrderId = "S" + x.Title_Code
                        }).ToList();

                        if (lstTitle.Count > 0)
                        {
                            Error.WriteLog_Conditional("STEP I CallSeries : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " Uploading String : SeriesPath = " + AssetPath);

                            Save_Scheduler_Log(SeriesPath, "", JsonConvert.SerializeObject(Acq_Series_Response));
                            var result = client.UploadString(SeriesPath, JsonConvert.SerializeObject(Acq_Series_Response));
                            Save_Scheduler_Log(SeriesPath, result);

                            Error.WriteLog_Conditional("STEP II CallSeries : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " Series Updoaded Successfully");
                        }

                        //Calling Playorder
                        foreach (var item in distinctTitleCode)
                        {
                            int TitleCode = Convert.ToInt32(item);
                            CallPlayOrder(TitleCode, lstAcq_Assets_Model);
                        }
                    }
                }
            }
        }
        public static void CallRights(List<SchedulerRight> lstSchedulerRight)
        {
            using (var client = new WebClient())
            {
                using (var context = new RightsU_PlusEntities())
                {
                    int[] arrSchedulerRightId = lstSchedulerRight.Select(x => x.SchedulerRightId).ToArray();
                    Update_SchedulerRights(arrSchedulerRightId, "W");

                    client.Headers.Clear();
                    client.Headers.Add("Content-Type:application/json");
                    client.Headers.Add("Accept:application/json");
                    if (IsAuthKeyRequired == "Y")
                        client.Headers.Add("Authorization", "Bearer " + AuthKey);

                    var Acq_Rights_Response = lstSchedulerRight.Select(x =>
                       new
                       {
                           _id = x.SchedulerRightId,
                           assetId = x.assetId.ToString(),
                           channelId = x.channelId.Split(',').ToArray(),
                           rightsStartDate = Convert.ToDateTime(x.rightsStartDate).ToString("yyyyMMddHHmmss"),
                           rightsEndDate = Convert.ToDateTime(x.rightsEndDate).ToString("yyyyMMdd") + "235959",
                           x.availableRun,
                           x.consumptionRun,
                           x.runType,
                           rightsRuleName = x.rightsRuleName ?? "",
                           is_First_Air = (x.Is_First_Air ?? 0) == 1 ? "Y" : "N",
                           //playPerRightsRule = x.runType == "U" ? 1 : x.runType == "C" ? -1 : x.playPerRightsRule,
                           playPerRightsRule = (x.rightsRuleName ?? "") == "" ? 1 : x.playPerRightsRule,
                           duration = x.duration ?? 0,
                           repeatPerRightsRule = x.repeatPerRightsRule ?? 0,
                           timeLag = x.timeLag == null ? -1 : x.timeLag.Value.TotalMinutes,
                           deleteflag = x.isArchive == "Y" ? 1 : 0
                       }
                    ).Take(RunDefBatch).ToList();
                    if (lstSchedulerRight.Count > 0)
                    {
                        Error.WriteLog_Conditional("STEP I CallRights : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " Uploading String : RunDefPath = " + AssetPath);

                        Save_Scheduler_Log(RunDefPath, "", JsonConvert.SerializeObject(Acq_Rights_Response), "", "P");
                        var result = client.UploadString(RunDefPath, JsonConvert.SerializeObject(Acq_Rights_Response));
                        Save_Scheduler_Log(RunDefPath, result, "", "", "P");

                        Error.WriteLog_Conditional("STEP II CallRights : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " Rights Updoaded Successfully");

                    }
                    Update_SchedulerRights(arrSchedulerRightId, "D");
                }
            }
        }
        public static void CallPlayOrder(int Title_Code, List<USP_Acq_Assets_Model_Result> lstAcq_Assets_Model)
        {
            using (var client = new WebClient())
            {
                using (var context = new RightsU_PlusEntities())
                {
                    client.Headers.Clear();
                    client.Headers.Add("Content-Type:application/json");
                    client.Headers.Add("Accept:application/json");
                    if (IsAuthKeyRequired == "Y")
                        client.Headers.Add("Authorization", "Bearer " + AuthKey);
                    var lst = lstAcq_Assets_Model.Where(x => x.Title_Code == Title_Code).ToList();
                    var Acq_PlayOrder_Response = lst.Select(x => new { _id = "S" + x.Title_Code, programs = lst.Select(y => y.C_id.ToString()).ToArray() }).Take(1).ToList();

                    if (lstAcq_Assets_Model.Count > 0)
                    {
                        Save_Scheduler_Log(PlayorderPath, "", JsonConvert.SerializeObject(Acq_PlayOrder_Response), "", "P");
                        var result = client.UploadString(PlayorderPath, JsonConvert.SerializeObject(Acq_PlayOrder_Response));
                        Save_Scheduler_Log(PlayorderPath, result, "", "", "P");
                    }
                }
            }
        }
        #endregion

        #region ------- CRUD METHOD -------------
        public static void Save_Scheduler_Log(string Request_Uri, string Request_JSON = "", string Response_JSON = "", string Error_Message = "", string Record_Status = "")
        {
            using (var context = new RightsU_PlusEntities())
            {
                Scheduler_Log objScheduler_Log = new Scheduler_Log();
                objScheduler_Log.Request_Type = "POST";
                objScheduler_Log.Request_Uri = Request_Uri;
                objScheduler_Log.Request_JSON = Request_JSON;
                objScheduler_Log.Response_JSON = Response_JSON;
                objScheduler_Log.Error_Message = Error_Message;
                objScheduler_Log.Record_Status = Record_Status;
                objScheduler_Log.Request_DateTime = System.DateTime.Now;
                context.Scheduler_Log.Add(objScheduler_Log);
                context.SaveChanges();
            }
        }
        public static void Update_SchedulerRights(int[] arrSchedulerRightId, string RecordStatus)
        {
            using (var context = new RightsU_PlusEntities())
            {
                foreach (int SchedulerRightId in arrSchedulerRightId)
                {
                    SchedulerRight objSchedulerRight = context.SchedulerRights.Where(x => x.SchedulerRightId == SchedulerRightId).FirstOrDefault();
                    objSchedulerRight.RecordStatus = RecordStatus;
                    context.Entry(objSchedulerRight).State = EntityState.Modified;
                    context.SaveChanges();
                }
            }
        }
        #endregion
    }
}
