﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html>
<head>
    <title>2015/4/15 - HoppingCode</title>
    <meta charset="utf-8">
    <style type="text/css">
        .line {
            margin-bottom: 10px;
        }

        #div_display {
            width: 100%;
            height: 100%;
            background-color: #EEEEEE;
            border: none;
        }

        body {
            margin: 0px;
            padding: 0px;
            overflow: hidden;
        }

        #div_input {
            position: fixed;
            right: 8px;
            top: 0px;
            height: 300px;
            width: 100px;
        }
        #text_display{
            width:100%;
            position: fixed;
            top : 10px;
            font-family: Arial,'Microsoft JhengHei';
            font-size : 20pt;
        }
    </style>
    <link href="Content/bootstrap.css" rel="stylesheet" />
</head>
<body>
    <div id="text_display"></div>

    <div id="div_display"></div>

    <div id="div_input">
        <button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal" id="ParameterSetting_btn">參數設定</button>

        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                        <h4 class="modal-title" id="myModalLabel">參數設定</h4>
                    </div>
                    <div class="modal-body">
                        <div class="container" style="width: 500px;">
                            
                            <div class="row line">
                                <div class="col-sm-12 text-left">參數</div>
                            </div>

                            <div class="row line">
                                <div class="col-sm-1 text-center">i：</div>
                                <div class="col-sm-2">
                                    <input type="text" size="1" id="Input_i">
                                </div>
                                <div class="col-sm-1 text-center">j：</div>
                                <div class="col-sm-2">
                                    <input type="text" size="1" id="Input_j">
                                </div>
                                <div class="col-sm-1 text-center">k：</div>
                                <div class="col-sm-2">
                                    <input type="text" size="1" id="Input_k">
                                </div>
                                <div class="col-sm-1 text-center">n：</div>
                                <div class="col-sm-2">
                                    <input type="text" size="1" id="Input_n">
                                </div>
                            </div>

                            <div class="row line">
                                <div class="col-sm-6 text-right">多少時間跑完(毫秒)：</div>
                                <div class="col-sm-6 text-left">
                                    <input type="text" size="3" id="Input_Time">
                                </div>
                            </div>

                            <div class="row line">
                                <div class="col-sm-12 text-center" id="input_state"></div>
                            </div>

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">關閉</button>
                        <button type="button" class="btn btn-primary btn-sm" id="input_btn" data-dismiss="modal">確定</button>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <img id="sprite7" src="images/7.jpg" style="display: none" />

    <script src="Scripts/jquery-2.1.3.js"></script>
    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/three.js"></script>
    <script src="Scripts/OrbitControls.js"></script>
    <script src="Scripts/Tween.js"></script>
    <script src="Scripts/theater.js"></script>
    <script>
        //-------------------------Get Reasult Data----------------------------------//
        var input_i, input_j, input_n;
        var renderer;

        $('#input_btn').click(function () {
            startCubeAnimate = false;
            
            input_i = document.getElementById("Input_i").value;
            input_j = document.getElementById("Input_j").value;
            input_k = document.getElementById("Input_k").value;
            input_n = document.getElementById("Input_n").value;
            var input_Time = document.getElementById("Input_Time").value;
            myTimeText = setInterval(function () { theater.write("text:等待回應中...");  }, 2000);
            //$("#input_state").text("連線中");
            $.ajax({
                type: "POST",
                url: "Default.aspx/Getdata",
                //async: false,
                data: JSON.stringify({
                    'i': input_i,
                    'j': input_j,
                    'k': input_k,
                    'n': input_n,
                }),
                contentType: "application/json; charset=UTF-8",
                dataType: "json",
                success: function (msg) {

                    //console.log(msg.d);

                    try {
                        var arr_from_json = JSON.parse(msg.d);
                        try {
                            
                            for (var i = 0; i < cubeGroup.length; i++) {
                                scene.remove(cubeGroup[i]);
                            }
                            clearInterval(myTimeText);
                            theater.write("text:資料庫連線中...OK");
                            theater.write("text:參數：i = " + input_i + ", j =" + input_j + ", k = " + input_k + ", n = " + input_n + ", " + input_Time / 1000 + "秒內執行完畢");
                            initObject(arr_from_json);
                        }
                        catch (err) {
                            clearInterval(myTimeText);
                            theater.write("text:" + msg.d);
                        }

                    } catch (err) {
                        clearInterval(myTimeText);
                        theater.write("text:" + msg.d);
                    }
                }

            });
        });

        /*$('#ParameterSetting_btn').click(function () {
            $("#input_state").text("");
        });*/

        //------------------------------------------------------------------------------//

        //-------------init theater.js -----------//

        var theater = new TheaterJS();
        theater.describe("text", { speed: 2, accuracy: .6, invincibility: 4 }, "#text_display");
        var myTimeText = setInterval(function () { theater.write("text:資料庫連線中..."); }, 2000);//設定每2秒執行一次

        //---------------------------------------//
        

        //-------------------------Three.js Main Code----------------------------------//

        var cubeGroup;
        var BackgroundScene;
        var BackgroundCamera;
        var BgCameraPos, BgCameraPos2, BgCount = 1;
        

        //設定初始值
        document.getElementById("Input_i").value = 0;
        document.getElementById("Input_j").value = 0;
        document.getElementById("Input_k").value = 0;
        document.getElementById("Input_n").value = 3;
        document.getElementById("Input_Time").value = 20000;

        input_i = document.getElementById("Input_i").value;
        input_j = document.getElementById("Input_j").value;
        input_k = document.getElementById("Input_k").value;
	input_n = document.getElementById("Input_n").value;



	$.urlParam = function(name){
		var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
		if(results){	
			return results[1] || 0;
		}
	}
		
	if (typeof $.urlParam("name")!='undefined') {
		input_n = $.urlParam("name");
	}


        //Get Reasult Data
        $.ajax({
            type: "POST",
            url: "Default.aspx/Getdata",
            //async: false,
            data: JSON.stringify({
                'i': input_i,
                'j': input_j,
                'k': input_k,
                'n': input_n,
            }),
            contentType: "application/json; charset=UTF-8",
            dataType: "json",
            success: function (msg) {

                //console.log(msg.d);

                try {
                    var arr_from_json = JSON.parse(msg.d);
                    try {
                        clearInterval(myTimeText);
                        theater.write("text:資料庫連線中...OK");
                        theater.write("text:參數: i=0 , j=0 , k=0 , n=3 , 20秒內執行完畢");
                        init(arr_from_json);
                    }
                    catch (err) {
                        clearInterval(myTimeText);
                        theater.write("text:" + err.message);
                        console.log(err.message);
                    }
                } catch (err) {
                    clearInterval(myTimeText);//取消time event
                    theater.write("text:" + msg.d);
                    console.log(msg.d);
                }
            }
        });
        //

        function init(data) {

            initRender();
            initcamera();
            initScene();
            var axisHelper = new THREE.AxisHelper(3000);
            scene.add(axisHelper);
            initLight();
            initObject(data);
            setSceneBackground();
            $("#div_display").on("mousedown", BackgroundRotate_S);
            $("#div_display").on("mouseup", function () {
                $("#div_display").off("mousemove");
                BgCount = 1;
            });
            controls.addEventListener('change', render);
            
            Animate();
        }

        var width;
        var height;
        

        function initRender() {
            renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setClearColor(0xffffff, 0.9);
            renderer.autoClear = true;
            document.getElementById("div_display").appendChild(renderer.domElement);
        }

        var camera;
        var controls;

        function initcamera() {
            camera = new THREE.PerspectiveCamera(50, window.innerWidth / window.innerHeight, 1, 1000);
            camera.position.x = 85;
            camera.position.y = 55;
            camera.position.z = 106;
            camera.up.x = 0;
            camera.up.y = 1;
            camera.up.z = 0;
            camera.lookAt({ x: 0, y: 0, z: 0 });
            controls = new THREE.OrbitControls(camera);
        }

        var scene;
        function initScene() {
            scene = new THREE.Scene;
        }

        var ambientLight;
        function initLight() {
            ambientLight = new THREE.AmbientLight(0xFFFAFA);
            scene.add(ambientLight);
        }

        var cubes = [];
        var targetposition = [];
        var singleTime;
        var originalPosition;
        var countNumber;
        var startCubeAnimate = false;
        var speed;

        function initObject(data) {
            
            singleTime = document.getElementById("Input_Time").value / data.length;
            originalPosition = { x: [], y: [] , z:[] };
            cubeGroup = [];
            countNumber = 0;

            //建立cbu並設定隨機的初始位子以及設定動畫
            for (var c = 0 ; c < data.length ; c++) {
                var canvas_data = document.createElement('canvas');
                canvas_data.height = 150;
                canvas_data.width = 150;
                var context_data = canvas_data.getContext('2d');
                var spriteData = $("#sprite7")[0];
                context_data.drawImage(spriteData, 0, 0);

                context_data.font = "40pt Helvetica";
                context_data.fillStyle = "rgba(255,0,0)";
                context_data.fillText(data[c].Step_No, 30, 90);
                var texture_data = new THREE.Texture(canvas_data);
                texture_data.needsUpdate = true;

                var material_data = new THREE.MeshLambertMaterial({
                    map: texture_data,
                    transparent: true,
                    opacity: 1
                });
                material_data.transparent = true;

                var cube = new THREE.Mesh(new THREE.BoxGeometry(5, 5, 5), material_data);
                cube.position.set(
                        positionRandom(),
                        positionRandom(),
                        positionRandom());

                cubeGroup.push(cube);

                scene.add(cube);
                
                var r = 30.0;  // 半徑
                var a = 45.0;  // 角度
                //設定camara移動到的位置

                //------------------待修改--------------------------------------
                //http://www.monmonkey.com/javascript/jiben5.html

                // originalPosition.x.push(data[c].i * 10 + r * Math.cos(a / 180 * Math.PI) );
                // originalPosition.y.push(data[c].j * 10 + r * Math.sin(a / 180 * Math.PI) );
                // originalPosition.z.push(data[c].k * 10 + r * Math.tan(a / 180 * Math.PI) );

                var data_pos_x = data[c].i * 10;
                var data_pos_y = data[c].j * 10;
                var data_pos_z = data[c].k * 10;
                var degree = Math.acos(data_pos_z / Math.pow(Math.pow(data_pos_x,2) + Math.pow(data_pos_z,2),0.5)) * (180 / Math.PI);

                originalPosition.x.push(input_n * 20 * Math.sin(((isNaN(degree) ? 45 : degree) / 180) * Math.PI));
                originalPosition.y.push( data_pos_y + 20 );
                originalPosition.z.push( input_n * 20 * Math.cos(((isNaN(degree) ? 45 : degree) / 180) * Math.PI));

                //console.log("degree:" + degree);
                //console.log("cos:" + Math.cos((degree / 180) * Math.PI));
                //console.log("sin:" + Math.sin((degree / 180) * Math.PI));

                //---------------------------------------------------------------

                //cube_Tween( 物件,X軸位子,Y軸位子,Z軸位子,速度,延遲時間(毫秒) )                
                cube_Tween(cube, data[c].i * 10, data[c].j * 10, data[c].k * 10, 1000, singleTime * c);
                
                speed = singleTime/1000;
                //speed = 0.01;
                startCubeAnimate = true;

            }
            //
        }

        

        function Animate() {
            
            requestAnimationFrame(Animate);
            render();
            TWEEN.update();
            controls.update();
            //console.log(camera.position)
            if (startCubeAnimate) {
                if (countNumber < (input_n * input_n * input_n)) {
                    if (Math.floor(camera.position.x - originalPosition.x[countNumber]) != 0) {
                        if (camera.position.x >= originalPosition.x[countNumber]) {
                            camera.position.x -= speed;
                        } else {
                            camera.position.x += speed;
                        }
                    }
                    if (Math.floor(camera.position.y - originalPosition.y[countNumber]) != 0) {
                        if (camera.position.y >= originalPosition.y[countNumber]) {
                            camera.position.y -= speed;
                        } else {
                            camera.position.y += speed;
                        }
                    }
                   if (Math.floor(camera.position.z - originalPosition.z[countNumber]) != 0) {
                        if (camera.position.z >= originalPosition.z[countNumber]) {
                            camera.position.z -= speed;
                        } else {
                            camera.position.z += speed;
                        }
                    }
                    //camera.lookAt({ x: cubeGroup[countNumber].position.x, y: cubeGroup[countNumber].position.y, z: cubeGroup[countNumber].position.z });
                    camera.lookAt({ x: 0, y: 0, z: 0 });
                } else {
                    startCubeAnimate = false;
                }
                //console.log(camera.position);
            }
            else {
                TWEEN.removeAll();
            }
        }

        function render() {

            renderer.autoClear = false;
            renderer.clear();
            renderer.render(BackgroundScene, BackgroundCamera);
            renderer.render(scene, camera);

        }
        
        function cube_Tween(target, x, y, z, duration, delaytime) {
            
            new TWEEN.Tween(target.position)
                    .to({ x: x, y: y, z: z }, duration)
                    .delay(delaytime)
                    .easing(TWEEN.Easing.Exponential.Out)
                    .start()
            .onComplete(function () {
                if (startCubeAnimate) {
                    if (countNumber >= 1) {
                        cubeGroup[countNumber - 1].material.opacity = 0.4;
                    }
                    countNumber++;
                }

                if (countNumber >= input_n * input_n * input_n ) {
                    for (i = 0 ; i < input_n * input_n * input_n ; i++) {
                        cubeGroup[i].material.opacity = 1;
                    }
                }
            });
            
        }

        function positionRandom() {
            var x = 0;
            var tf = true;
            while (tf) {
                x = Math.random() * 3000 - 1000;
                if (x < -1000 || x > 1000) {
                    tf = false;
                    return x;
                }
            }
        }

        function setSceneBackground() {
            var Backgroundtexture = THREE.ImageUtils.loadTexture('./images/sky.jpg');
            var BackgroundMesh = new THREE.Mesh(
                    new THREE.PlaneGeometry(3, 3, 0),
                    new THREE.MeshBasicMaterial({ map: Backgroundtexture })
            );
            BackgroundMesh.material.depthTest = false;
            BackgroundMesh.material.depthWrite = false;
            BackgroundScene = new THREE.Scene();
            BackgroundCamera = new THREE.Camera();
            BackgroundScene.add(BackgroundCamera);
            BackgroundScene.add(BackgroundMesh);
        }

        function BackgroundRotate_S() {
            var posX = event.x;
            var posY = event.y;
            $(this).on("mousemove", {
                value: posX,
                value2: posY
            }, function (e) {
                if (BgCount == 1) {
                    BgCameraPos = e.data.value;
                    BgCameraPos2 = e.data.value2;
                    BgCount++;
                }
                var currentX = event.x;
                var currentY = event.y;
                if (currentX > BgCameraPos && BackgroundCamera.position.x > -0.5) {
                    BackgroundCamera.position.x -= 0.01;
                    BgCameraPos = currentX;
                } else if (currentX < BgCameraPos && BackgroundCamera.position.x < 0.5) {
                    BackgroundCamera.position.x += 0.01;
                    BgCameraPos = currentX;
                }
                if (currentY > BgCameraPos2 && BackgroundCamera.position.y > -0.5) {
                    BackgroundCamera.position.y -= 0.01;
                    BgCameraPos2 = currentY;
                } else if (currentY < BgCameraPos2 && BackgroundCamera.position.y < 0.5) {
                    BackgroundCamera.position.y += 0.01;
                    BgCameraPos2 = currentY;
                }

            });
        }

    </script>
</body>
</html>
