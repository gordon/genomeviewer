/* register event handlers */
document.onmouseup = up;
document.onmousedown = down;
document.onmousemove = move;

/* initialize global variables */
var isMousePressed = false;
var offset = 0;

/*  parses the URI and returns the value of a parameter of the GET request */
function getParamValue(param) {
 parastring=window.location.search.substring(1,window.location.search.length);
 paramarray=parastring.split("&");
 for(i=0; i<paramarray.length; i++) {
  if (paramarray[i].substring(0,param.length)==param) {
   return paramarray[i].split("=")[1];
  }
 }
 return "undefined";
}

/* Determines the X position of the cursor */
function getXPosition(mp) {
 if (!mp) mp=window.event;
 var _x;
 _x = mp.clientX + document.body.scrollLeft;
 return _x;
}


function down(mp) {
 isMousePressed = true;
 offset = getXPosition(mp) - parseInt(document.body.style.backgroundPosition.split(' ')[0]);
}

function up() {
 isMousePressed=false;
 var imgOffset = parseInt(document.body.style.backgroundPosition.split(' ')[0]);
 if (imgOffset != 0) {
  var startPos     = getParamValue('start_pos');
  var endPos       = getParamValue('end_pos');
  var imgWidth     = 800;
  var bp_per_pixel = (endPos-startPos)/imgWidth;
  var shift        = Math.round(imgOffset*bp_per_pixel);
  var newEndPos    = Number(endPos)-shift;
  var newStartPos  = Number(startPos)-shift;
  /* alert("m2.html?endPos="+newEndPos+"&fileName=annotation.gff3&startPos="+newStartPos); */
  window.location.href = "browser?end_pos="+newEndPos+"&file_name=annotation.gff3&start_pos="+newStartPos+"&annotation="+getParamValue('annotation')+"&seq_id="+getParamValue('seq_id');
 }
}

function move(mp) {
 if(isMousePressed) {
  var _x = getXPosition(mp);
  document.body.style.backgroundPosition=_x-offset+"px 0px";
 }
}

function go_left() {
 var startPos     = parseInt(getParamValue('startPos'));
 var endPos       = parseInt(getParamValue('endPos'));
 quarter          = Math.round( (endPos-startPos) / 4 );
 var newStartPos  = startPos-quarter;
 var newEndPos    = endPos-quarter;

 window.location.href = "browser?end_pos="+newEndPos+"&file_name=annotation.gff3&start_pos="+newStartPos+"&annotation="+getParamValue('annotation')+"&seq_id="+getParamValue('seq_id');
}

function go_right() {
 var startPos     = parseInt(getParamValue('start_pos'));
 var endPos       = parseInt(getParamValue('end_pos'));
 quarter          = Math.round( (endPos-startPos) / 4 );
 var newStartPos  = startPos+quarter;
 var newEndPos    = endPos+quarter;

 window.location.href = "browser?end_pos="+newEndPos+"&file_name=annotation.gff3&start_pos="+newStartPos+"&annotation="+getParamValue('annotation')+"&seq_id="+getParamValue('seq_id');
}

function zoom_in() {
 var startPos     = parseInt(getParamValue('start_pos'));
 var endPos       = parseInt(getParamValue('end_pos'));
 quarter          = Math.round( (endPos-startPos) / 4 );
 var newStartPos  = startPos+quarter;
 var newEndPos    = endPos-quarter;

 window.location.href = "browser?end_pos="+newEndPos+"&file_name=annotation.gff3&start_pos="+newStartPos+"&annotation="+getParamValue('annotation')+"&seq_id="+getParamValue('seq_id');
}

function zoom_out() {
 var startPos     = parseInt(getParamValue('start_pos'));
 var endPos       = parseInt(getParamValue('end_pos'));
 quarter          = Math.round( (endPos-startPos) / 4 );
 var newStartPos  = startPos-quarter;
 var newEndPos    = endPos+quarter;

 window.location.href = "browser?end_pos="+newEndPos+"&file_name=annotation.gff3&start_pos="+newStartPos+"&annotation="+getParamValue('annotation')+"&seq_id="+getParamValue('seq_id');
}