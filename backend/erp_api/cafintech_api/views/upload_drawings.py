import os
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.conf import settings
from rest_framework.permissions import IsAuthenticated

class FileUploadView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, format=None):
        file_obj = request.FILES.get('drawing')
        if not file_obj:
            return Response({"error": "No file provided"}, status=status.HTTP_400_BAD_REQUEST)

        # custom folder (outside MEDIA_ROOT if you want)
        cid = request.user.cid.cid
        upload_dir = 'S:\\DRAWINGS\\' + cid + "\\"                    # change this path
        os.makedirs(upload_dir, exist_ok=True)

        save_path = os.path.join(upload_dir, file_obj.name)

        with open(save_path, 'wb+') as destination:
            for chunk in file_obj.chunks():
                destination.write(chunk)

        return Response({
            "message": "File uploaded successfully!",
            "filename": file_obj.name,
            "path": save_path,
            "drawing" : "http://erp.rcinz.com/drw/" + cid + "/" + file_obj.name
        }, status=status.HTTP_201_CREATED)
