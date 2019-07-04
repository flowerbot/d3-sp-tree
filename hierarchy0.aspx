<%@ Register TagPrefix="WpNs0" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<!DOCTYPE html>
<%@ Page language="C#" inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<head>
	<title>BrightWork Hierarchy</title>
<meta name="ProgId" content="SharePoint.WebPartPage.Document">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/select2/3.5.0/select2.min.css" />

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/select2/3.5.0/select2.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@8"></script>
<script src="/SiteAssets/scripts/promise-polyfill.js" ></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.4/clipboard.min.js"></script>
<link href="https://fonts.googleapis.com/css?family=Kite+One" rel="stylesheet">


<style>
	/*http://www.jdawiseman.com/papers/trivia/character-entities.html*/
	/* <script src="https://cdn.jsdelivr.net/npm/promise-polyfill" ></script> */


.small {
			 font-family: 'courier new', sans-serif;
			 font-size: x-small;
}

	.node {
		cursor: pointer;
	}

	.node circle {
		fill: #fff;
		stroke: steelblue;
		stroke-width: 1.5px;
	}

	.found {
		fill: #ff4136;
		stroke: #ff4136;
	}
	.node text {
		font: 11px sans-serif;
	}

	#tree {
		overflow: visible;
	}

	.link {
		fill: none;
		stroke: #ccc;
		stroke-width: 1.5px;
	}
	/*Just to ensure the select2 box is "glued" to the top*/
	.search {
	  width: 300px;
	  display:inline-block;

	}
	.searchContainer {
		width:100%;
	}

	.select2-result-label, #select2-chosen-1, select2-choice {
	  font-family:Arial, Helvetica, sans-serif !important;
	  font-size: 12px;
	}

	#webLink, #nodeDescription {
	display:inline-block;
		 /* font-family:Arial, Helvetica, sans-serif !important;	 */
		 font-family: 'Kite One', sans-serif;
	  font-size: 12px;
	  padding-left:15px;

	}

	h2 {
	 font-family: 'Kite One', sans-serif;
	/* font-family:Arial, Helvetica, sans-serif; */
	font-size:medium;

	}

	.searchTextDiv {
			 font-family: 'Kite One', sans-serif;
			  /* font-family:Arial, Helvetica, sans-serif !important; */
	  font-size: 12px;

}

#nodeInfo {
	display:inline-block;

	}




.notepad {

	display:block;
   /*  font-family: 'Handlee', cursive; */
   position: absolute;
   left: 600px;
   top: 0;
    padding: 25px 20px;
    margin: 50px auto;
    min-width: 200px;
    max-width: 600px;
    height: auto;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.2), inset 0 0 50px rgba(0, 0, 0, 0.1);
    transform: rotate(-1deg);
    -ms-transform: rotate(-1deg);
    -moz-transform: rotate(-1deg);
    -o-transform: rotate(-1deg);
    -webkit-transform: rotate(-1deg);
    background: #fcf59b !important;
	background:
		-webkit-gradient(
			linear,
			left top, left bottom,
			from(#81cbbc),
			color-stop(2%, #fcf59b)
		);
	background:
		-moz-repeating-linear-gradient(
			top,
			#fcf59b,
			#fcf59b 38px,
			#81cbbc 40px
		);
	background:
		repeating-linear-gradient(
			top,
			#fcf59b,
			#fcf59b 38px,
			#81cbbc 40px
		);
	-webkit-background-size: 50% 40px;
}

.notepad:hover {
		cursor: move;
}

.deptnode {
	forecolor: green;
}

}





.hidden {
	visibility: hidden;
	display: none;

}

.display {
	visibility: visible;
	display: block;

}



/* The Modal (background) */
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  padding-top: 100px; /* Location of the box */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
  background-color: #fefefe;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 60%;
}

/* The Close Button */
.close {
  color: #aaaaaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: #000;
  text-decoration: none;
  cursor: pointer;
}

.waitmsg {
	font-family: Verdana;


}

.dataDate {
		 font-family: 'Kite One', sans-serif;
	font-size: small;
}

table.listinfo {
	padding: 0;
}
tr.listinfo td  {
/*	display:flex;
	flex-direction:row; */
	padding:0.3rem 0.3rem;
	margin:0 1rem;
	transition:all .5s ease;
	    background:transparent;
	 outline:none;
/*	box-shadow: 20px 38px 34px -26px hsla(0,0%,0%,.2); */
	border-radius: 255px 15px 225px 15px/15px 225px 15px 255px;
	 /* border-bottom:solid 1px #41403E; */
	 	 border-bottom:solid 1px #63625e;
}


.hideTable, .hideData {
/*	visibility: hidden; */
	display: none;

}

#dataToggle, #dataDesc {
	font-family: 'Kite One', sans-serif !important;
}

.togglelink {
	backcolor: yellow;
}

.swal2-input {
	height: 100;
}

</style>


<!-- This will be attached to select2, only static element on the page -->
<html xmlns:mso="urn:schemas-microsoft-com:office:office" xmlns:msdt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882">
<!--[if gte mso 9]><SharePoint:CTFieldRefs runat=server Prefix="mso:" FieldList="FileLeafRef,WikiField,_dlc_DocId,_dlc_DocIdUrl,_dlc_DocIdPersistId"><xml>
<mso:CustomDocumentProperties>
<mso:_dlc_DocId msdt:dt="string">NKVJFX2TJXEK-2001238712-35</mso:_dlc_DocId>
<mso:_dlc_DocIdItemGuid msdt:dt="string">b7efb2d4-482b-445c-92e9-6c48954ba00b</mso:_dlc_DocIdItemGuid>
<mso:_dlc_DocIdUrl msdt:dt="string">http://tscps/prac/skills/web/_layouts/15/DocIdRedir.aspx?ID=NKVJFX2TJXEK-2001238712-35, NKVJFX2TJXEK-2001238712-35</mso:_dlc_DocIdUrl>
</mso:CustomDocumentProperties>
</xml></SharePoint:CTFieldRefs><![endif]-->
</head>
<body>
	<!-- The Modal -->


	<div id="myModal" class="modal">

	  <!-- Modal content -->
	  <div class="modal-content">
	    <span class="close">&times;</span>
			<div class='reloadingImg'> <img class="reloadingImg" align='left' src="/projects/admin/SiteAssets/images/reloadIcon.gif"/>
			</div>
    <div class="waitmsg">Please wait, getting data.  Your next refresh can reuse this data and will be much quicker.  <br />Click cancel if prompted to sign in with your credentials - this indicates sites with restrictive permissions which cannot be included in results.</div>

	  </div>
<!-- <form id="form1" runat="server"> -->
<!-- Uncomment above and matching </form> tag to re-enable _spPageContextInfo in this page - removed to stop Chrome prompting with nonsense on refresh-->
	</div>
<h2>Tweed Shire Council BrightWork Hierarchy</h2>
<div class='dataDate' title='To enable fast results after the first call of this page, data is saved in your browser until you manually refresh by clicking the button'>
	<input type="button" id="RefreshBtn" value="Refresh Data"></input>  Data date: <span id='dataDate'></span><input type="button" id="ExportBtn" value="Export Data"><input type="button" id="ImportBtn" value="Import Data">


</div>
<div class="searchTextDiv">Search the hierarchy ...</div><div id="searchContainer"><div id="search">if the hierarchy does not appear, try viewing this in Edge or Chrome</div><div class="notepad"><div id="nodeInfo"><div id="webLink">Click a node for links and info</div>
<span id="nodeDescription"></span></div></div></div>

<!-- Main -->
<script type="text/javascript">

	//basically a way to get the path to an object
	function searchTree(obj,search,path){
		//root.removeClass("found");
		//root.children.forEach(collapse);
		//root.children.forEach.classed("found",false);
		//d3.select(".found").classed("found",false);


		if(obj.name === search){ //if search is found return, add the object to the path and return it
		//	path = [];
			path.push(obj);
			return path;
		}
		else if(obj.children || obj._children){ //if children are collapsed d3 object will have them instantiated as _children
			var children = (obj.children) ? obj.children : obj._children;

			for(var i=0;i<children.length;i++){
				path.push(obj);// we assume this path is the right one
				var found = searchTree(children[i],search,path);
				if(found){// we were right, this should return the bubbled-up path from the first if statement
					return found;
				}
				else{//we were wrong, remove this parent from the path and continue iterating
					path.pop();
				}
			}
		}
		else{//not the right object, return false so it will continue to iterate in the loop
			return false;
		}
	}



function sortFunction(a, b) {
    if (a[0] === b[0]) {
        return 0;
    }
    else {
        return (a[0] < b[0]) ? -1 : 1;
    }
}


	function extract_select2_data(node,leaves,index){
	        if (node.children){
								//	console.log("children:" + node.children.length);
	            for(var i = 0;i<node.children.length;i++){
	                index = extract_select2_data(node.children[i],leaves,index)[0];
	            }
	            leaves.push({id:++index,text:node.name});  //do the parent too

	        }
	        else {
	            leaves.push({id:++index,text:node.name});
	        }
	       // myArray = sortFunction([index,leaves]);
	       // console.log([index,leaves]);
	     //  console.log(myArray);
		//	 console.log('finished in extract leaves');
	        return [index, leaves];
	       //return myArray;
	}
	//ie not body
	var div = d3.select("body")
		.append("div") // declare the tooltip div
		.attr("class", "tooltip")
		.style("opacity", 0);

	var margin = {top: 20, right: 120, bottom: 20, left: 120},
		width = 1250 - margin.right - margin.left,
		height = 800 - margin.top - margin.bottom;

	var i = 0,
		duration = 750,
		root,
		select2_data;

	var diameter = 960;

	var tree = d3.layout.tree()
		.size([height, width]);

	var diagonal = d3.svg.diagonal()
		.projection(function(d) { return [d.y, d.x]; });

	var svg = d3.select("body").append("svg")
		.attr("width", width + margin.right + margin.left)
		.attr("height", height + margin.top + margin.bottom)
		.attr("id", "tree")
	  	.append("g")
		.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

	//recursively collapse children
	function collapse(d) {
		if (d.children) {
			d._children = d.children;
			d._children.forEach(collapse);
			d.children = null;
		}
	}

		function removeclass(d) {
		//if (d.children) {
			//d._children = d.children;
			//d._children.forEach(removeclass);
			//d.children = null;
			var myvar = d3.selectAll("svg.stroke").classed("found",null);
			console.log(myvar);
		//}
		//d3.d.classed("found",false);
	}


	// Toggle children on click.
	function click(d) {
		if (d.children) {
				if (d.children.length > 40) {
					tree.size([height, width]);
				}
			d._children = d.children;
				d.children = null;
	  	}
	  	else{

			d.children = d._children;
			d._children = null;
	  	}

		if (d.children) {
			if (d.children.length > 40) {
			console.log("greater than 40, "+d.children.length);
			tree.size([height+(d.children.length*8),width]);
			d3.select("#tree").attr("height", function() {return height+ (d.children.length*10);});
			}
		}

	  	var tempdesc = "";
	  	var tempurl = "Click a node for links and info";
	  	//var tempnodetype = "";

	  	if (d.desc) { tempdesc = d.desc; };


	  	if (d.url) {
	  	var tempUrl
	  	if (d.url.substring(1,4) != "http")
	  	{
	  		tempUrl = bwAddress + d.url;
	  	}
	  	else
	  	{
	  		tempUrl = d.url;
	  	}
	  	tempurl = "Node clicked: <a href='"+tempUrl + "' target='_blank'>" + d.name + "</a>";
	  	}

		//	if(d.listsObj === null) {
			///get contents
			var listsObj = [];
			var listsDesc = "";
			//var listDesc = "";

			$.ajax({
				url: bwAddress + d.url + "/_api/web/lists?$select=ParentWebUrl,Title,Description,BaseTemplate",
			//	url: _spPageContextInfo.siteAbsoluteUrl + SubSiteUrl + "/_api/web/webinfos?$select=*",
				method: "GET",
				headers: {
					"Accept": "application/json; odata=verbose"
				},
				success: function(lists) {



					$.each(lists.d.results, function(index) {

					  if(this.BaseTemplate != 110 && this.BaseTemplate != 116 && this.BaseTemplate != 124 && this.BaseTemplate != 733) {
					//if(this.BaseTemplate != 733){
			      try {
						if (this.ParentWebUrl != "/") {
								level = this.ParentWebUrl.split("/").length - 1;

								listsObj.push({
							//	parentObj.children.push({
								"key": this.Title,
								"name": this.Title,
								"url":this.ParentWebUrl,
								"desc": this.Description
							//	"type": this.EntityTypeName
							//	"level": level,
							//	"parent": SubSiteUrl,
							//	"parentTitle": SubSiteTitle,
							//	"children": []
							})
							}




							//listObj = parentObj;
					//    $('#resultsTable tr:last').after("<tr><td><p style='text-indent:"+indent+"px;'>"+this.Title + "</span></td><td><a href='"+this.ServerRelativeUrl+"'>"+this.ServerRelativeUrl+"</a></td></tr>");
				//	var rowStr = "<tr><td nowrap><p style='text-indent:"+(level*10) +"px;'>"+this.Title + "</span></td><td><a href='"+this.ServerRelativeUrl+"'>"+this.ServerRelativeUrl+"</a></td>";


					//	console.log(level + " from " + this.ServerRelativeUrl);

					//	getSubSites(this.ServerRelativeUrl, this.Title, level, parentObj);
						//d3.select(".reloadingImg").classed("hidden", null);
			    } catch (ex) {
			      console.log(ex);
			    }
				} // end fi
					});

					if(listsObj.length >0 ) {
						d["listsObj"] = listsObj;
					listsDesc += "<div><a href='#' id='toggleContent'>Site Contents</a></div>";
					 listsDesc += "<table class='hideTable listinfo'>";

					listsObj.forEach(function(item, i){

				/*		var tmpType = item.type;
						tmpType = tmpType.replace(/_x0020_/g," ");
						tmpType = tmpType.replace(/_x005f_/g,"_");
							tmpType = tmpType.replace(/_x002f_/g,"/");
							tmpType = tmpType.replace(/_x002d_/g,"-"); */
//(List Type:"+tmpType+")
						listsDesc += "<tr class='listinfo'><td>" + item.name + "</td><td>" + item.desc + "</td></tr>";
					});
					listsDesc += "</table>";
					}


					$("#nodeDescription").html(tempdesc + listsDesc);
					$("#webLink").html(tempurl);
				update(d);
					//$(".reloadingImg").toggleClass("hidden");
			//d3.select(".reloadingImg").classed("hidden", "true");
				},
				error: function(subsites) {
					try {
							$("#nodeDescription").html(tempdesc);
							$("#webLink").html(tempurl);
						 update(d);
					 } catch (ex) {}
				},
				 async: false

				// $("#nodeDescription").html("SITE NOT REACHED TO CHECK FOR LISTS");
				 //$("#webLink").html(tempurl);
		//	 update(d);
			});
	  	//}
	//	} else {
			// already got the contents


	//	}

	  //	console.log("nodetype:" + d.nodetype);
	  	/*
	  	var codeStart = "";
	  	var codeEnd = "";

	  		if (d.nodetype == "Department")
	  	{
	  		codeStart = "<span class='deptnode'>";
	  		codeEnd = "</span>";
	  	}
	  	*/

	  	//$("#nodeDescription").html(codeStart+tempdesc+codeEnd);

	}

	function openPaths(paths){

			removeclass();
		for(var i =0;i<paths.length;i++){
			if(paths[i].id !== "1"){//i.e. not root
				paths[i].class = 'found';
				if(paths[i]._children){ //if children are hidden: open them, otherwise: don't do anything
					paths[i].children = paths[i]._children;
	    			paths[i]._children = null;
				}

				update(paths[i]);
			}

		}
	}








var bwAddress = "http://tscppm";
//var redraw = false;

function drawFromScratch(refresh) {

//d3.select(".reloadingImg").classed("hidden", null);



var level;

console.log('refresh:' + refresh)

var newAll = [];
//localStorage.clear();


if(localStorage.getItem("BWHierarchy") === null || refresh == true) {
/*
try {
d3.selectAll('svg').data().remove();
} catch (ex) { }
*/
//d3.select("body .reloadingImg").classed("hidden", null);
//$("body .reloadingImg").show();
//$(".reloadingImg").removeClass("hidden");
	document.getElementById("myModal").style.display = "block";
//setTimeout(function() {
console.log("building new data set");

//var L1, L2, L3, L4, L5;

var data2 = [{
	"key":"BrightWork PPM",
	"name": "BrightWork PPM",
  "url": "/",
  "desc": "<- Click to visit the BrightWork SharePoint, Tweed Shire Council's Project and Portfolio Management System",
	"level": 0,
	"children": []
}];

var newObj;

/*
$.ajaxSetup({
         statusCode: {
             401: function(){
                 // Redirec the to the login page.
                // location.href = "./login.cfm";
                return;
             }
         }
     });
*/
function getSubSites(SubSiteUrl, SubSiteTitle,level, parentObj) {
//d3.select(".reloadingImg").classed("hidden", null);
	//	$(".reloadingImg").removeClass("hidden");
$.ajax({
//	url: _spPageContextInfo.siteAbsoluteUrl + SubSiteUrl + "/_api/web/webinfos?$select=ServerRelativeUrl,Title,Description",
	url: bwAddress + SubSiteUrl + "/_api/web/webinfos?$select=ServerRelativeUrl,Title,Description",

//	url: _spPageContextInfo.siteAbsoluteUrl + SubSiteUrl + "/_api/web/webinfos?$select=*",
	method: "GET",
	headers: {
		"Accept": "application/json; odata=verbose"
	},
	success: function(subsites) {

		$.each(subsites.d.results, function(index) {
      try {
			if (this.ServerRelativeUrl != "/") {
					level = this.ServerRelativeUrl.split("/").length - 1;

					data2.push({
				//	parentObj.children.push({
					"key": this.Title,
					"name": this.Title,
					"url":this.ServerRelativeUrl,
					"desc": this.Description,
					"level": level,
					"parent": SubSiteUrl,
					"parentTitle": SubSiteTitle,
				//	"children": []
				})
				}



				newObj = parentObj;
		//    $('#resultsTable tr:last').after("<tr><td><p style='text-indent:"+indent+"px;'>"+this.Title + "</span></td><td><a href='"+this.ServerRelativeUrl+"'>"+this.ServerRelativeUrl+"</a></td></tr>");
		var rowStr = "<tr><td nowrap><p style='text-indent:"+(level*10) +"px;'>"+this.Title + "</span></td><td><a href='"+this.ServerRelativeUrl+"'>"+this.ServerRelativeUrl+"</a></td>";


		//	console.log(level + " from " + this.ServerRelativeUrl);

			getSubSites(this.ServerRelativeUrl, this.Title, level, parentObj);
			//d3.select(".reloadingImg").classed("hidden", null);
    } catch (ex) {
      console.log(ex);
    }
		});
		//$(".reloadingImg").toggleClass("hidden");
//d3.select(".reloadingImg").classed("hidden", "true");
	},
	error: function(subsites) {},
	 async: false
});
}


 getSubSites("/", "BrightWork PPM", -1, data2);


var nestedByLevel = d3.nest()
.key(function(d) {return d.level })
.sortValues(function (a, b) { return b.level - a.level }) //reverse sort
.entries(data2);


 nestedByLevel.forEach(function (LV,e,arr2) {
		LV.values.forEach(function (LA,d,arr) {
			var tmpArr = pullChildren(LA.name, data2);
			if (tmpArr.length > 0) {
				LA["children"] = tmpArr;
			}
		})

		newAll.push(LV.values);
	//	return LV
});

//d3.select("body .reloadingImg").classed("hidden", "true");
		//	 $(".reloadingImg").toggleClass("hidden");
	//		 $(".reloadingImg").removeClass("display");
localStorage.setItem("BWHierarchy", JSON.stringify(newAll));
var dDate =  new Date();
localStorage.setItem("BWHierarchyDate", dDate);

//}, 100); // end of timeout
//redraw = false;
} // end if localstorage doesn't exist
else {
  console.log("retrieving saved dataset");
  //newAll.push([]);
//	d3.select(".reloadingImg").classed("hidden", "true");
	// $(".reloadingImg").toggleClass("hidden");
//	 	 $(".reloadingImg").removeClass("display");
  newAll = JSON.parse(localStorage.getItem("BWHierarchy"));
//d3.select(".reloadingImg").classed("hidden", "true");
}

$("#dataDate").html(localStorage.getItem("BWHierarchyDate"));
console.log(JSON.parse(localStorage.getItem("BWHierarchy")));
//console.log(newAll[0][0]);
//console.log(newAll);

function pullChildren(name, arr) {
	var tmpArr = [];
	 arr.forEach(function (d) {
		if (d.parentTitle == name) {
			tmpArr.push(d);
		}
	})
	return tmpArr;
}




/*
function datanest(d){
 node = root = {values: d3.nest()
      .key(function(d) { return d.parentTitle; })
			.key(function(d) { return d.level; })
      .rollup(function(d) {
        return d.map(function(d) {
          return {key: d.name };
        });
      })
      .entries(data2)};
	  return node;
	  return root;
	}

*/
//console.log(newData);


	function redraw()
	{

		removeclass();
		root.children.forEach(collapse);

		update(root);

		/* var node = svg.selectAll("g.node")
			.data(nodes, function(d) { return d.id || (d.id = ++i); });

			node.selectAll("circle")
			.attr("r", 4.5)
			.style("fill", "lightsteelblue") //red
			.style("stroke", "lightsteelblue");
*/

	}



	//d3.json("spHierarchy.txt", function(error,values){
	//	root = data;
	//	root = level0Data[0];
		root = newAll[0][0];
		console.log(newAll);
		console.log(root);
	//	console.log(newAll[0]);
	//	root = data2;
	//	root = newData;
	//	select2_data = extract_select2_data(data2,[],0)[1];//I know, not the prettiest...
				select2_data = extract_select2_data(newAll[0][0],[],0)[1];//I know, not the prettiest...

		 select2_data = select2_data.sort(function(a, b){
		    		            return a.text < b.text ? -1 : a.text > b.text ? 1 : 0;
				});

		//console.log($(select2_data));
		root.x0 = height / 2;
		root.y0 = 0;
		root.children.forEach(collapse);
		update(root);
		//init search box

		$("#search").select2({

			data: select2_data,
			containerCssClass: "search"
		});

	//attach search box listener
	$("#search").on("select2-selecting", function(e) {
		var paths = searchTree(root,e.object.text,[]);
		if(typeof(paths) !== "undefined"){

			openPaths(paths);
		}
		else{
			alert(e.object.text+" not found!");
		}
	})

	d3.select(self.frameElement).style("height", "800px");





} //end drawFromScratch


drawFromScratch(false);



function update(source) {


	// Compute the new tree layout.
	var nodes = tree.nodes(root).reverse(),
	links = tree.links(nodes);

	// Normalize for fixed-depth.
	nodes.forEach(function(d) { d.y = d.depth * 180; });

	// Update the nodesâ€¦
	var node = svg.selectAll("g.node")
		.data(nodes, function(d) { return d.id || (d.id = ++i); });

	// Enter any new nodes at the parent's previous position.
	var nodeEnter = node.enter().append("g")
		.attr("class", "node")
	.attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
	.on("click", click);

	nodeEnter.append("circle")
	.attr("r", 1e-6)
	.style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

	nodeEnter.append("text")
		.attr("x", function(d) { return d.children || d._children ? -10 : 10; })
		.attr("dy", ".35em")
		.attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
		.text(function(d) { return d.name; })
		.style("fill-opacity", 1e-6)
		.attr("fill", function(d) {
		if (d.nodetype == "Department")
		{
			console.log(d.nodetype);
		return "gray";
		}
		else
		{
			//return "pink";
		}
		});



	// Transition nodes to their new position.
	var nodeUpdate = node.transition()
		.duration(duration)
		.attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });
	/*	.each(function () {
			$(".reloadingImg").removeClass("hidden");
		}); */

	nodeUpdate.select("circle")
		.attr("r", 4.5)
		.style("fill", function(d) {
			if(d.class === "found"){
				return "#ff4136"; //red
			}
			else if(d._children){
				return "lightsteelblue";
			}
			else{
				return "#fff";
			}
		})
		.style("stroke", function(d) {
			if(d.class === "found"){
				return "#ff4136"; //red
			}
			/*else if(d._children){
				return "lightsteelblue";
			}
			else{
				return "#fff";
			}*/

	});

	nodeUpdate.select("text")
		.style("fill-opacity", 1);

	// Transition exiting nodes to the parent's new position.
	var nodeExit = node.exit().transition()
		.duration(duration)
		.attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
		.remove();

	nodeExit.select("circle")
		.attr("r", 1e-6);

	nodeExit.select("text")
		.style("fill-opacity", 1e-6);

	// Update the linksâ€¦
	var link = svg.selectAll("path.link")
		.data(links, function(d) { return d.target.id; });

	// Enter any new links at the parent's previous position.
	link.enter().insert("path", "g")
		.attr("class", "link")
		.attr("d", function(d) {
			var o = {x: source.x0, y: source.y0};
			return diagonal({source: o, target: o});
		});

	// Transition links to their new position.
	link.transition()
		.duration(duration)
		.attr("d", diagonal)
		.style("stroke",function(d){
			if(d.target.class==="found"){
				return "#ff4136";
			}
		}).call(endAll, function() {
		//	alert('finished');
		modal.style.display = "none";
		$(".reloadingImg").addClass("hidden");
		});

	// Transition exiting nodes to the parent's new position.
	link.exit().transition()
		.duration(duration)
		.attr("d", function(d) {
			var o = {x: source.x, y: source.y};
			return diagonal({source: o, target: o});
		})
		.remove();

	// Stash the old positions for transition.
	nodes.forEach(function(d) {

		d.x0 = d.x;
		d.y0 = d.y;
		});
};


function endAll (transition, callback) {
    var n;

    if (transition.empty()) {
        callback();
    }
    else {
        n = transition.size();
        transition.each("end", function () {
            n--;
            if (n === 0) {
                callback();
            }
        });
    }
}
//d3.select(".reloadingImg").classed("hidden", true);

$(document).ready( function() {
$(".notepad").draggable();

});
/*
$('#RefreshBtn').on('click', function() {

	//	$(".reloadingImg").addClass("display");
	$(".reloadingImg").removeClass("hidden");
	refreshData();
})
*/
//localStorage.clear();
function refreshData() {

//$(".reloadingImg").toggleClass("hidden");
//d3.select(".reloadingImg").classed("hidden", null);
//document.getElementById("reloading").display = "block";
		localStorage.clear();

		//alert('test');

	$(".reloadingImg").removeClass("hidden");
//	$("#tree").addClass("hidden");

	//	$("#tree").hide();

	//	d3.select('svg#tree').selectAll("*").remove();

	drawFromScratch(true);

}






// Get the modal
var modal = document.getElementById("myModal");

// Get the button that opens the modal
var btn = document.getElementById("RefreshBtn");
var expbtn = document.getElementById("ExportBtn");
var imptbtn = document.getElementById("ImportBtn");
// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// When the user clicks the button, open the modal
btn.onclick = function() {
	$(".reloadingImg").removeClass("hidden");
		modal.style.display = "block";
	setTimeout(function() {
refreshData();
}, 1000);

//  modal.style.display = "block";
}


expbtn.onclick = function() {
//	$(".reloadingImg").removeClass("hidden");
var input = swal.fire({
	title: "Export Data",
	html: "<div id='dataDesc'>Click OK to copy data from this chart to your clipboard  "+
	"<input id='dataToggle' class'togglelink' type='button' value='show data'></input></div>"+
			"<div class='small hideData' id='dataText'>" + localStorage.getItem("BWHierarchy")+ "</div>",
	width: "50%",
	showCancelButton: true,
	preConfirm: function () {
		var dummyContent = document.getElementById('dataText').innerHTML;
		var dummy = $('<input id="dummy">').val(dummyContent).appendTo('body').select();
		document.execCommand('copy');

    return  [
      document.getElementById('dataText').text,
			document.getElementById("dataText") //,
		//	dummy
    //dataText  document.getElementById('swal-input2').value
	]
	}
}).then(function(expobj) {

	console.log(expobj);

	if(Array.isArray[expobj]) {

	var dummy = document.getElementById('dummy');
	dummy.parentNode.removeChild(dummy);
	}

try {
	var dummy = document.getElementById('dummy');
	dummy.parentNode.removeChild(dummy);
} catch (ex) {}
//	document.getElementById("dataText").select();

	/*var clipboard = new Clipboard(expbtn); */
	/*clipboard.on('success', function(e) {
		console.log('copied text');
		console.log(e.text);
	}); */


});

//  modal.style.display = "block";
}

// only implement if no native implementation is available
if (typeof Array.isArray === 'undefined') {
  Array.isArray = function(obj) {
    return Object.prototype.toString.call(obj) === '[object Array]';
  }
};

//imptbtn.onclick = async function() {
imptbtn.onclick =  function() {
//	$(".reloadingImg").removeClass("hidden");
	//	modal.style.display = "block";
//	var input = swal.fire({
	//const {value: impData} = await Swal.fire({
	Swal.fire({
		title: "Paste complete JSON text below:",
		input: 'text',
		inputPlaceholder: 'paste properly formed JSON object as text',
		width: "80%",

	}).then(function(obj) {
		console.log(obj);
		//tempObj = [];


		if (IsJsonString(obj.value)) {
			localStorage.setItem("BWHierarchy", obj.value);
			var dDate =  new Date();
			localStorage.setItem("BWHierarchyDate", "(Imported) "+ dDate);
			setTimeout(function() {
				drawFromScratch(false);
				}, 1000);
		} else {
			Swal.fire("not a valid JSON string");
		}
	//	newAll = JSON.parse(obj.value);

	})

	/*setTimeout(function() {
refreshData();
}, 1000); */

//  modal.style.display = "block";
}

function IsJsonString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
  modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) {
    modal.style.display = "none";
  } else {
  	if (event.target == document.getElementById("toggleContent"))
		{
		//	console.log('toggling')
				$("table.listinfo").toggleClass("hideTable");
		} else {
			if(event.target == document.getElementById("dataToggle")) {
				$(".small").toggleClass("hideData");
			}
		}
  }
}


</script>
<ZoneTemplate></ZoneTemplate>
<!-- </form> -->
<!--add above tag and its starting tag if necessary, see comment with starting tag for more info -->
</body>
