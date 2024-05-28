using System;
using System.Collections.Generic;
using System.Linq;
using Elasticsearch.Net;
using Nest;
using RightsU_Plus.Models;

public class Elastic
{
    ElasticClient client = null;
    public Elastic()
    {
        var uri = new Uri("http://192.168.0.83:9200");
        var settings = new ConnectionSettings(uri);
        client = new ElasticClient(settings);
        settings.DefaultIndex("company");
    }
    public List<T> GetResult<T>(string indexName) where T : ClsBase, new()
    {
        List<T> lst = new List<T>();

        if (client.Indices.Exists(indexName).Exists)
        {
            var response = client.Search<T>();

            foreach (var hit in response.Hits)
            {
                T d = new T();

                d = hit.Source;
                d.id = hit.Id;
                lst.Add(d);
            }

            return lst;
        }
        return null;
    }

    public List<T> GetResult<T>(string condition, string indexName, bool withId) where T : ClsBase, new()
    {
        List<T> lst = new List<T>();

        if (client.Indices.Exists(indexName).Exists)
        {
            var query = condition;

            if (!withId)
                return client.SearchAsync<T>(s => s
            .From(0)
            .Take(10)
            .Query(qry => qry
                .Bool(b => b
                    .Must(m => m
                        .QueryString(qs => qs
                            .DefaultField("_all")
                            .Query(query)))))).Result.Documents.ToList();
            else
            {
                var response = client.Search<T>(s => s
                                     .From(0)
                                     .Take(10)
                                     .Query(qry => qry
                                        .Bool(b => b
                                            .Must(m => m
                                                .QueryString(qs => qs
                                                    .DefaultField("_all")
                                                    .Query(query))))));
                foreach (var hit in response.Hits)
                {
                    T d = new T();

                    d = (T)hit.Source;
                    d.id = hit.Id;
                    lst.Add(d);
                }

                return lst;
            }

        }
        return null;
    }

    public string CreateDocument<T>(string indexName, T c, string documentId) where T : class
    {
        var response = client.Index<T>(c, i => i
        .Index(indexName)
        .Id(documentId)
        .Refresh(Refresh.True));
        return response.Id;
    }

    public List<T> GetDocument<T>(string indexName, string documentId) where T : ClsBase, new()
    {
        List<T> lst = new List<T>();

        var response = client.Search<T>(s => s
        .Index(indexName)
        .Query(q => q.Term(u => u.Field("_id").Value(documentId))));
        foreach (var hit in response.Hits)
        {
            T d = new T();

            d = (T)hit.Source;
            d.id = hit.Id;
            lst.Add(d);
        }
        return lst;
    }

    public void UpdateDocument<T>(string indexName, T c, string documentId) where T : class
    {
        var response = client.Index(c, i => i
        .Index(indexName)
        .Id(documentId)
        .Refresh(Refresh.True));
    }

    public void DeleteDocument<T>(string indexName, string documentId) where T : class
    {
        var response = client.Delete<T>(documentId, d => d
        .Index(indexName));
    }

    public void DeleteIndex(string indexName)
    {
        if (!client.Indices.Exists(indexName).Exists)
        {
            client.Indices.Delete(indexName);
        }
    }
    public void CreateIndex(string indexName)
    {
        if (!client.Indices.Exists(indexName).Exists)
        {
            client.Indices.Create(indexName);
        }
    }
}