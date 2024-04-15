﻿using RightsU.API.DAL;
using RightsU.API.DAL.Repository;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.BLL.Services
{
    public class BMSServices
    {
        private readonly BMSAssetRepositories objBMSAssetRepositories = new BMSAssetRepositories();
        private readonly BMSDealRepositories objBMSDealRepositories = new BMSDealRepositories();
        private readonly BMSDealContentRepositories objBMSDealContentRepositories = new BMSDealContentRepositories();
        private readonly BMSDealContentRightsRepositories objBMSDealContentRightsRepositories = new BMSDealContentRightsRepositories();
        private readonly BMSUploadData_Repositories objBMSUploadDataRepositories = new BMSUploadData_Repositories();

        /// <summary>
        /// Get Assets
        /// </summary>
        /// <param name="since"></param>
        /// <returns></returns>
        public List<AssetsResult> GetAssets(string since)
        {
            List<AssetsResult> lstUSPGetBMSAssets = new List<AssetsResult>();
            lstUSPGetBMSAssets = objBMSAssetRepositories.GetAssets(since).ToList();
            return lstUSPGetBMSAssets;
        }
        /// <summary>
        /// Get Deals
        /// </summary>
        /// <param name="since"></param>
        /// <param name="AssetId"></param>
        /// <returns></returns>
        public List<DealResult> GetDeals(string since,string AssetId)
        {
            List<DealResult> lstUSPGetBMSDeals = new List<DealResult>();
            lstUSPGetBMSDeals = objBMSDealRepositories.GetDeals(since,AssetId).ToList();
            return lstUSPGetBMSDeals;
        }

        /// <summary>
        /// Get Deal Contents
        /// </summary>
        /// <param name="since"></param>
        /// <param name="AssetId"></param>
        /// <param name="DealId"></param>
        /// <returns></returns>
        public List<DealContentResult> GetDealContent(string since, string AssetId,string DealId)
        {
            List<DealContentResult> lstUSPGetBMSDealContent = new List<DealContentResult>();
            lstUSPGetBMSDealContent = objBMSDealContentRepositories.GetDealContent(since, AssetId,DealId).ToList();
            return lstUSPGetBMSDealContent;
        }

        /// <summary>
        /// Get Deal Content Rights
        /// </summary>
        /// <param name="since"></param>
        /// <param name="AssetId"></param>
        /// <param name="DealId"></param>
        /// <returns></returns>
        public List<DealContentRightsResult> GetDealContentRights(string since, string AssetId, string DealId)
        {
            List<DealContentRightsResult> lstUSPGetBMSDealContentRights = new List<DealContentRightsResult>();
            lstUSPGetBMSDealContentRights = objBMSDealContentRightsRepositories.GetDealContentRights(since, AssetId, DealId).ToList();
            return lstUSPGetBMSDealContentRights;
        }
        public int BMSUploadData(DataTable dt, string FileType, int ChannelCode)
        {
            return objBMSUploadDataRepositories.BMSUploadData(dt, FileType, ChannelCode);
        }
    }
}