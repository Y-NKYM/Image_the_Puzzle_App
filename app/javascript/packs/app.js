$(function(){
if ((navigator.userAgent.indexOf('iPhone') > 0 && navigator.userAgent.indexOf('iPad') == -1) || navigator.userAgent.indexOf('iPod') > 0 || navigator.userAgent.indexOf('Android') > 0) {
    var parentWidth  = 256;     // 外枠の幅  （px）
    var parentHeight = 256;   // 外枠の高さ（px）
  } else {
    var parentWidth  = 600;     // 外枠の幅  （px）
    var parentHeight = 600;     // 外枠の高さ（px）
  }

  $("#settingBlock").css("width", parentWidth+"px");  // パズルの枠と入力部品エリアの幅を合わせる（見た目の調整）

  setOutLine();   // パズルの外枠を設置する(1)

  /** 初期値 **/
  var W = 3;  // 横の個数
  var H = 3;  // 縦の個数

  var blankId;            // 空きスペースID
  var parentBlock;        // 外枠のdiv要素
  var imgObj;             // 画像オブジェクト


  /**
   * 1. パズルの外枠を設置する
   **/
   function setOutLine() {
      parentBlock = document.createElement("div");
      document.querySelector("#puzzle").appendChild(parentBlock);
      parentBlock.id = "parentBlock";
      parentBlock.style.width  = parentWidth+"px";
      parentBlock.style.height = parentHeight+"px";
      parentBlock.style.position = "relative";
      // parentBlock.style.border = "2px solid #000000";
      // parentBlock.style.border = "2px solid #000000";
  }


  //** イメージを読み込む **//
  // $("#urlBtn").on("click",function(){
      // setImage($('#url').val());
  setImage($('#sample-image').attr('src'));
  // });

  //** スライダーバーを動かす **//
  $("#range_w").on("change",function(){
      W = this.value;
      setImage(imgObj.src);
      document.getElementById('output1').value=this.value;
  });
  $("#range_h").on("change",function(){
      H = this.value;
      setImage(imgObj.src);
      document.getElementById('output2').value=this.value;
  });

  $("#puzzle_reset").on("click",function(){
      setImage($('#sample-image').attr('src'));
  });



  /**
   * 配列をランダムに並び替えて取得する
   * @param   {Array} arr  並び替える前の配列
   * @return  {Array}      並び替えた配列
   **/
  function getRandamArray(arr) {
      for (var cnt=arr.length-1; cnt>=0; cnt--) {
          var rnd = Math.floor(Math.random()*(cnt+1));
          var tmp = arr[cnt];
          arr[cnt] = arr[rnd];
          arr[rnd] = tmp;
      }
      console.log(arr);
      return arr;
  }


  /**
   * ブロックをクリックする
   * @param {object} ev    イベントハンドラ
   **/
   let move_counter = 0;
   function clickEv(ev) {
      ev.stopPropagation();
      var moveId = ev.target.id.replace("block","");
      moveBlock(ev.target)
  }

  /**
   * 4. ブロックを移動させる
   * @param {object} comp    コンポーネント
   **/

   function moveBlock(comp) {


      // (4-1)クリックしたブロックの隣に「空きスペース」があるかを判定する
      // 動かすブロック、空きスペースの情報を取得
      //** (4-1) start **/
      var moveId = comp.id.replace("block","")    // 動かすブロックID
      var moveId0 = moveId.split("_")[0];     // 動かすブロックの行ID
      var moveId1 = moveId.split("_")[1];     // 動かすブロックの列ID
      var blankId0 = blankId.split("_")[0];   // 空きスペースの行ID
      var blankId1 = blankId.split("_")[1];   // 空きスペースの列ID

      var moveFlg = false;    // 判定フラグ
      if (moveId0 == blankId0) {
          if (Math.abs(moveId1-blankId1) == 1) {  // 動かすブロックと空きスペースが隣り合ってる
              moveFlg = true;
          }
      } else if (moveId1 == blankId1) {
          if (Math.abs(moveId0-blankId0) == 1) {  // 動かすブロックと空きスペースが隣り合ってる
              moveFlg = true;
          }
      }
      //** (4-1) end **/
      //** (4-2) start **/

      if (moveFlg) {  // (4-2)移動可能な場合、クリックしたブロックを空きスペースに移動させる
          // クリックしたスペースIDと空白スペースIDを入れ替える
          var _moveId = moveId;
          moveId = blankId;
          blankId = _moveId;
          // ブロックの位置を入れ替える
          comp.style.top = comp.height*blankId0+"px";
          comp.style.left  = comp.width*blankId1+"px";
          comp.id = "block"+blankId0+"_"+blankId1;
          move_counter += 1;
          let puzzle_move = document.getElementById("puzzle_move");
          puzzle_move.innerHTML = `${move_counter}回`;
      }
      //** (4-2) end **/
  }


  /**
   * ブロックに画像をセットする
   * @param {String} url   画像のURL
   **/
  function setImage(url) {
      if (url == "") {
          alert("URLを入力してください");
          return;
      }

      $("#range_box").css("display","block");     // スライダーバーを表示させる
      $(parentBlock).empty();         // ブロック要素をすべて消す
      $("#url").val("");

      // ブロックIDの格納用配列の初期化
      var blockIdArr = new Array();
      blockIdArr.length = 0;

      /** 2. ブロックの配置方法を決める
      （2-1）パズルのスペースとIDを決め、
      （2-2）空きスペースをランダムに決める
      **/
      //** (2-1～2-2) start **/
      var rnd = Math.floor(Math.random()*((W*H)-1));  //　[空きスペースの位置をランダムに取得] 0～(マス目の数-1)までの整数から、ランダムに数値を取得する
      var counter = 0;
      for (var cnt1=0; cnt1<H; cnt1++) {
          for (var cnt2=0; cnt2<W; cnt2++) {
              if (counter == rnd) {       // ランダムに取得した値とcounterの値が一致したときに、空きスペースIDをセットする
                  blankId = "2_2";    // 空きスペースID
              }
              blockIdArr[counter] = cnt1+"_"+cnt2;
              counter++;
          }
      }
      //** (2-1～2-2) end **/

      blockIdArr = getRandamArray(blockIdArr);   // パズルをランダムに配置するために、ブロック番号を並び替える（2-3）

      // 画像を読み込ませる(2-3)
      imgObj = new Image();
      imgObj.src = url;
      imgObj.onload = function() {
          var counter = 0;

          // ブロックごとに順番に画像を配置する
          for (var cnt1=0; cnt1<H; cnt1++) {
              for (var cnt2=0; cnt2<W; cnt2++) {
                  if (blankId != cnt1+"_"+cnt2) {
                      //canvas（ブロック）を生成する（※本文中では説明省略）
                      var canvas = document.createElement("canvas");
                      canvas.id = "block"+cnt1+"_"+cnt2;
                      canvas.width  = parentWidth/W;
                      canvas.height = parentHeight/H;
                      parentBlock.appendChild(canvas);

                      // canvas（ブロック）を配置する（※本文中では説明省略）
                      canvas.style.position = "absolute";
                      canvas.style.width  = parentWidth/W+"px";
                      canvas.style.height = parentHeight/H+"px";
                      canvas.style.top  = canvas.height*cnt1+"px";
                      canvas.style.left = canvas.width*cnt2+"px";

                      /* 3. ブロックをランダムに並び替えて配置する */
                      // IDをもとに、そのブロックに表示される画像の位置・大きさ情報を設定
                      //** (3) start **/
                      var imgDim = imgObj.width/W;
                      if (imgDim > imgObj.height/H) {
                        imgDim = imgObj.height/H;
                      }
                      var rand1 = blockIdArr[counter].split("_")[1];
                      var rand2 =  blockIdArr[counter].split("_")[0];
                    //   var sx = (imgObj.width/W)*rand1;
                    //   var sy = (imgObj.height/H)*rand2;
                      var sx = imgDim*rand1;
                      var sy = imgDim*rand2;
                    //   var sw = imgObj.width/W;
                    //   var sh = imgObj.height/H;
                      var sw = imgDim;
                      var sh = imgDim;
                      var dx = 0;
                      var dy = 0;
                      var dw = canvas.width;
                      var dh = canvas.height;

                      var context = canvas.getContext("2d");
                      context.lineWidth = 1;      // 枠線の太さ
                      // 画像を配置
                      context.drawImage(imgObj,sx,sy,sw,sh,dx,dy,dw,dh);
                      context.beginPath();
                      context.strokeRect(0, 0, dw, dh);
                      canvas.addEventListener("click", clickEv, true);
                      //** (3) end **/
                  }
                  counter++;
              }
          }
          // 小数の影響による外枠の大きさの微調整
          $("#parentBlock").css("width", (canvas.width)*W+"px");
          $("#parentBlock").css("height", (canvas.height)*H+"px");
      }

  }
});