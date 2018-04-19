#r "System.Web"

using System.Net;
using System.Web;

public static async Task<HttpResponseMessage> Run(HttpRequestMessage req, TraceWriter log)
{
    dynamic data = await req.Content.ReadAsAsync<object>();

    string clientIP = ((HttpContextWrapper)req.Properties["MS_HttpContext"]).Request.UserHostAddress;

    if(data.key == "yourkey")
    {
        log.Info($"C# HTTP trigger function processed a request with body key = {data.key}, ingredient = {data.ingredient}, client ip = {clientIP}");
        return req.CreateResponse(HttpStatusCode.OK,"");
    }
    else
    {
        return req.CreateResponse(HttpStatusCode.Forbidden);
    }
}
