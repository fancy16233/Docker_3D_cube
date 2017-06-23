using System;
using System.Web.Services;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.Script.Serialization;
using System.Text;
using Newtonsoft.Json;
using System.IO;


public partial class _Default : System.Web.UI.Page
{
    static SqlConnection conn;

    [WebMethod(EnableSession = false)]
    public static object Getdata( string i, string j, string k, string n)
    {
        string connectStr = "Data Source=tcp:163.18.21.223;Persist Security Info=True;Password=GhOst1945;User ID=sa;Initial Catalog=Knight_Tour_3D";
        string state = ConnectToSql(connectStr);

        if (state == "OK")
        {

            SqlCommand cmd = new SqlCommand();

            cmd.Connection = conn;


            cmd.Parameters.Clear();
            cmd.CommandType = CommandType.StoredProcedure; //指定要做StoredProcedure型態
            cmd.CommandText = "Knight_tour_boostversion";

            
            try
            {
                cmd.Parameters.Add("@i", SqlDbType.Int).Value = int.Parse(i);
                cmd.Parameters.Add("@j", SqlDbType.Int).Value = int.Parse(j);
                cmd.Parameters.Add("@k", SqlDbType.Int).Value = int.Parse(k);
                cmd.Parameters.Add("@n", SqlDbType.Int).Value = int.Parse(n);
                cmd.Parameters.Add("@rState", SqlDbType.Int).Value = -1;
                cmd.Parameters["@rState"].Direction = ParameterDirection.ReturnValue;

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();

                if ((int)cmd.Parameters["@rState"].Value == 0)
                {
                    cmd = new SqlCommand();
                    cmd.CommandText = "SELECT * FROM Board order by Step_No";
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = conn;
                    SqlDataReader reader;
                    conn.Open();

                    reader = cmd.ExecuteReader();

                    StringBuilder sb = new StringBuilder();
                    StringWriter sw = new StringWriter(sb);

                    using (JsonWriter jsonWriter = new JsonTextWriter(sw))
                    {
                        jsonWriter.WriteStartArray();

                        while (reader.Read())
                        {
                            jsonWriter.WriteStartObject();

                            int fields = reader.FieldCount;

                            for (int r = 0; r < fields; r++)
                            {
                                jsonWriter.WritePropertyName(reader.GetName(r));
                                jsonWriter.WriteValue(reader[r]);
                            }

                            jsonWriter.WriteEndObject();
                        }
                        jsonWriter.WriteEndArray();
                    }

                    return sb.ToString();

                }
                else
                {
                    return "StoredProcedure error";
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                cmd.Cancel();
                conn.Close();
                conn.Dispose();
            }

        }
        else
        {
            return state;
        }

    }

    [WebMethod(EnableSession = false)]
    public static string ConnectToSql(string connectStr)
    {
        conn = new System.Data.SqlClient.SqlConnection();
        // TODO: Modify the connection string and include any
        // additional required properties for your database.

        conn.ConnectionString = connectStr;

        try
        {
            conn.Open();
            // Insert code to process data.
            return "OK";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
        finally
        {
            conn.Close();
        }
    }
}