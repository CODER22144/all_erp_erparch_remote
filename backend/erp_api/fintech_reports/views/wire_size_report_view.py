from django.db import connections

from django.http import JsonResponse
from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from CaFinTech.errors import UNSUCCESSFUL_REQUEST
from CaFinTech.utility import generate_error_message
import json

from cafintech_api.views.bill_receipt_view import ConvertToJson
from fintech_reports.serializers.wire_size_report_serializer import MatAssemblyComparisonSerializer, WireSizeReportSerializer, WsAssemblyReportSerializer, WsReportSerializer

def getWireSizeReport(request):
    try:
        matno = request.GET.get("matno")
        repId = request.GET.get("repId")
        soId = request.GET.get("soId")

        serializer = WireSizeReportSerializer(data={'matno':matno, 'repId':repId, 'soId':soId})    
        if(serializer.is_valid()):
            cursor = connections[request.GET.get("cid")].cursor()
            cursor.execute(f"EXEC [cost].[WireSizeTl] %s",(json.dumps(serializer.data),))
            json_data = ConvertToJson(cursor)
            
        context = {
            "ws" : json_data[0],
            "details" : json.loads(json_data[0]['wiredetail'])
        }
        cursor.close()
        return render(request, "wireSizetl.html", context)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)
    

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getWsReport(request):
    try:
        serializer = WsReportSerializer(data=request.data)
        if(serializer.is_valid()):
            cursor = connections[request.user.cid.cid].cursor()
            cursor.execute(f"EXEC [cost].[WireSizeReport] %s",(json.dumps(serializer.data),))
            json_data = ConvertToJson(cursor)
            cursor.close()
            return JsonResponse(json_data, safe=False)
        UNSUCCESSFUL_REQUEST['message'] = serializer.errors
        return Response(UNSUCCESSFUL_REQUEST, status=400)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getWsAssemblyReport(request):
    try:
        serializer = WsAssemblyReportSerializer(data=request.data)
        if(serializer.is_valid()):
            cursor = connections[request.user.cid.cid].cursor()
            cursor.execute(f"EXEC [cost].[uspGetWireSizeDetails] %s",(json.dumps(serializer.data),))
            json_data = [data[0] for data in cursor.fetchall()]
            json_data = "".join(json_data)
            cursor.close()
            return Response(json.loads(json_data))
        UNSUCCESSFUL_REQUEST['message'] = serializer.errors
        return Response(UNSUCCESSFUL_REQUEST, status=400)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getPbCostingReport(request):
    try:
        serializer = WsReportSerializer(data=request.data)
        if(serializer.is_valid()):
            cursor = connections[request.user.cid.cid].cursor()
            cursor.execute(f"EXEC [cost].[ProductBreakupCostReport] %s",(json.dumps(serializer.data),))
            json_data = ConvertToJson(cursor)
            cursor.close()
            return JsonResponse(json_data, safe=False)
        UNSUCCESSFUL_REQUEST['message'] = serializer.errors
        return Response(UNSUCCESSFUL_REQUEST, status=400)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getPartAssemblyCosting(request):
    try:
        serializer = WsReportSerializer(data=request.data)
        if(serializer.is_valid()):
            cursor = connections[request.user.cid.cid].cursor()
            cursor.execute(f"EXEC [cost].[PartAssemblyCostReport] %s",(json.dumps(serializer.data),))
            json_data = ConvertToJson(cursor)
            cursor.close()
            return JsonResponse(json_data, safe=False)
        UNSUCCESSFUL_REQUEST['message'] = serializer.errors
        return Response(UNSUCCESSFUL_REQUEST, status=400)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getPartSubAssemblyCosting(request):
    try:
        serializer = WsReportSerializer(data=request.data)
        if(serializer.is_valid()):
            cursor = connections[request.user.cid.cid].cursor()
            cursor.execute(f"EXEC [cost].[PartSubAssemblyCostReport] %s",(json.dumps(serializer.data),))
            json_data = ConvertToJson(cursor)
            cursor.close()
            return JsonResponse(json_data, safe=False)
        UNSUCCESSFUL_REQUEST['message'] = serializer.errors
        return Response(UNSUCCESSFUL_REQUEST, status=400)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getMaterialAssemblyCosting(request):
    try:
        serializer = WsReportSerializer(data=request.data)
        if(serializer.is_valid()):
            cursor = connections[request.user.cid.cid].cursor()
            cursor.execute(f"EXEC [cost].[MaterialAssemblyCostReport] %s",(json.dumps(serializer.data),))
            json_data = ConvertToJson(cursor)
            cursor.close()
            return JsonResponse(json_data, safe=False)
        UNSUCCESSFUL_REQUEST['message'] = serializer.errors
        return Response(UNSUCCESSFUL_REQUEST, status=400)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)


def getOldWireSizeReport(request):
    try:
        material = request.GET.get("matno")
        cursor = connections[request.GET.get("cid")].cursor()
        cursor.execute(f"EXEC [cost].[OldWireSize] %s",(material,))
        json_data = ConvertToJson(cursor)
        
        context = {
            "ws" : json_data            
        }
        cursor.close()
        return render(request, "old_wire_size.html", context)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)


def wsReportForTLWithWireSizeNo(request):
    try:
        material = request.GET.get("matno")
        cursor = connections[request.GET.get("cid")].cursor()
        cursor.execute(f"EXEC [cost].[WireSizeRep] %s",(material,))
        json_data = [data[0] for data in cursor.fetchall()]
        json_data = "".join(json_data)
        cursor.close()
        
        context = {
            "ws" : json.loads(json_data)
        }
        cursor.close()
        return render(request, "ws-by-wireno.html", context)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)

def getWireSizeAssemblyReportFormat(request):
    try:
        material = request.GET.get("matno")
        assno = request.GET.get("assno")
        repId = request.GET.get("repId")
        cursor = connections[request.GET.get("cid")].cursor()
        cursor.execute(f"EXEC [cost].[uspGetWireSizeDetails] %s",(json.dumps({"matno" : material, 'assno' : assno, 'repId' : repId}),))
        json_data = [data[0] for data in cursor.fetchall()]
        json_data = "".join(json_data)
        cursor.close()
        
        context = {
            "ws" : json.loads(json_data)
        }
        cursor.close()
        if repId == 'W' or repId == 'O':
            return render(request, "wireSizetl.html", context)
        return render(request, "ws-assembly.html", context)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getWireSizeMaterial(request):
    try:
        serializer = WsAssemblyReportSerializer(data=request.data)
        if(serializer.is_valid()):
            cur = connections[request.user.cid.cid].cursor()
            cur.execute(f"EXEC [cost].[uspGetWireSizeAss] %s,%s",(request.data['matno'],request.data['assno']))
            jsn = []
            row_headers=[x[0] for x in cur.description]
            rv = cur.fetchall()
            for result in rv:
                jsn.append(dict(zip(row_headers,result)))
            cur.close()
            return JsonResponse(jsn, safe=False)
        UNSUCCESSFUL_REQUEST['message'] = serializer.errors
        return Response(UNSUCCESSFUL_REQUEST, status=400)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)
    
# PB COSTING Hyperlink on HTML Report on Part No.
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getPbCostingMaterialSource(request):
    try:
        cursor = connections[request.user.cid.cid].cursor()
        cursor.execute(f"EXEC [purchase].[uspGetBymatnoMaterialSource] %s",(request.data['matno'],))
        json_data = ConvertToJson(cursor)
        cursor.close()
        return JsonResponse(json_data, safe=False)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def getMaterialAssemblyComparison(request):
    try:
        serializer = MatAssemblyComparisonSerializer(data=request.data)
        if(serializer.is_valid()):
            cursor = connections[request.user.cid.cid].cursor()
            cursor.execute(f"EXEC [cost].[PartAssembleComparison] %s",(json.dumps(serializer.data),))
            json_data = ConvertToJson(cursor)
            cursor.close()
            return JsonResponse(json_data, safe=False)
        UNSUCCESSFUL_REQUEST['message'] = serializer.errors
        return Response(UNSUCCESSFUL_REQUEST, status=400)
    except Exception as e:
        return Response(generate_error_message(e), status=500, exception=e)