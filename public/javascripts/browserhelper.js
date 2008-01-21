/* register event handlers */
document.onmousemove = move;


/* initialize global variables */
var isMousePressed = false;
var offset = 0;
var mousexpos = 0;

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


function down() {
 isMousePressed = true;
 offset = mousexpos - parseInt(document.getElementById("annoimg").offsetLeft);
}

function move(mp) {
 mousexpos=document.all ? window.event.clientX : mp.pageX;
 if(isMousePressed) {
  var _x = getXPosition(mp);
  document.getElementById("annoimg").style.left=_x-offset;
 }
}

function up() {
 isMousePressed=false;
 var imgOffset = parseInt(document.getElementById("annoimg").offsetLeft);
 if (imgOffset != 0) {
  var startPos     = getParamValue('start_pos');
  var endPos       = getParamValue('end_pos');
  var imgWidth     = 800;
  var bp_per_pixel = (endPos-startPos)/imgWidth;
  var shift        = Math.round(imgOffset*bp_per_pixel);
  var newEndPos    = Number(endPos)-shift;
  var newStartPos  = Number(startPos)-shift;
  window.location.href = "browser?end_pos="+newEndPos+"&file_name=annotation.gff3&start_pos="+newStartPos+"&annotation="+getParamValue('annotation')+"&seq_id="+getParamValue('seq_id');
 }
}
