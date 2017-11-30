/**
 * @author elee
 */

exportUrl = campaignAdsGetUrl;

editSogouUrl=campaignAdsSogouUpdateUrl;
editThreesixtiesUrl=campaignAdsThreesixtiesUpdateUrl;
editBaiduUrl=campaignAdsBaiduUpdateUrl;
editShenmaUrl=campaignAdsShenmaUpdateUrl;

var aoColumns = [];
for(var i=0;i<21;i++){
	// aoColumns.push({ "asSorting": [ "desc", "asc" ] });
}


$('#ads-table thead tr th').each(function() {
	
	var show_class = $(this).attr("class");
	
	if (show_class != null && show_class.indexOf("js-sort-show") >= 0){
		aoColumns.push({ "asSorting": [ "desc", "asc" ] });	
	}
	
})


var adsTableOption = {
	// bFilter: false,
	/* http://datatables.net/release-datatables/examples/basic_init/dom.html */
	"sDom": '<"table-responsive"rt>pil',
	"aLengthMenu": page_option,
	"language": {
		"info": "Page _PAGE_ of _PAGES_",
		"lengthMenu": "No. of Rows: _MENU_",
		"paginate": {
			"previous": "<<",
			"next": ">>"
		},
		"emptyTable":"There is no data available for the selected period. Select a different date range to view performance data."
	},
	"oLanguage": {
		"sInfo": "Page _PAGE_ of _PAGES_",
		"sLengthMenu": "No. of Rows: _MENU_",
		"oPaginate": {
			"sPrevious": "<<",
			"sNext": ">>"
		},
		"sEmptyTable":"There is no data available for the selected period. Select a different date range to view performance data."
	},
	"processing": true,
	"serverSide": true,
	"ajax": {
		"url":exportUrl,
		"type":"POST",
		"data": function(d){
			var filter_object=[];

			$(".filter_row").each(function(){
				if($(this).find("[name=field_value]").val()!=''){
					var filter={};

					filter.name=$(this).find("[name=field_name]").val();
					filter.rule=$(this).find("[name=field_rule]").val();
					filter.value=$(this).find("[name=field_value]").val();

					filter_object.push(filter);
				}
			});

			d.filter_object = filter_object;
			d.start_date = $("#start_date").val();
			d.end_date = $("#end_date").val();
			d.campaign_type = $("#campaign_type").val();
			d.campaign_id = $("#campaign_id").val();
			d.network_id = $("#network_id").val();
			d.adgroup_id = $("#adgroup_id").val();
			d.csv=0;

			exportData=d;

			return d;
		},

	},
	"fnDrawCallback": function( oSettings ) {
		
		
		var response = this.api().ajax.json();
		var all_conversion_business_type = response.all_conversion_business_type;
		var return_conversion_array_total = response.return_conversion_array_total;

		
		
		$.each(return_conversion_array_total, function(key,valueObj){
			$('#'+key+"_total").replaceWith('<th class="'+key+'" id="'+key+'_total">'+accounting.formatNumber(valueObj,2)+'</th>');
		});
		
		
		
		$('#ads-table thead tr th').each(function(index ) {
       		
       		th_this = $(this);
       		
       		class_str = th_this.attr('class');
       		class_str_arr = class_str.split(" ");
       		
       		// console.log(class_str +" _ "+index);
       		
       		class_str_arr.forEach(function(class_str_arr_d) {
       			correct_html_index = index + 1
				if(all_conversion_business_type.includes(class_str_arr_d)){
	       			// console.log("sad_ "+index+"_"+class_str_arr_d);
					$('#ads-table tbody td:nth-child('+correct_html_index+')').addClass(class_str_arr_d);	       			
	       		}    
			});
       	});
       	
       	
       	$('.switch_conversion_type').each(function(index ) {
			
			if($(this).is(':checked') == true){
	        	$("."+$(this).val()).show();
	        	$("."+$(this).val()+"revenue").show();
	        }else{
	        	$("."+$(this).val()).hide();
	        	$("."+$(this).val()+"revenue").hide();
	        } 
			
		});
       	
       	$('.switch_conversion_type').change(function() {
	        // $(this).val($(this).is(':checked'));
	        // console.log($(this).val());       
	        // console.log($(this).is(':checked'));
	        
	        if($(this).is(':checked') == true){
	        	$("."+$(this).val()).show();
	        	$("."+$(this).val()+"revenue").show();
	        }else{
	        	$("."+$(this).val()).hide();
	        	$("."+$(this).val()+"revenue").hide();
	        } 
	    });
		
		
		
		$.each(all_conversion_business_type, function(key,valueObj){
			// console.log(valueObj);
			
			$('td.'+valueObj).each(function(index ) {
				td_this = $(this);
				td_this.text(accounting.formatNumber(td_this.text(),2));
				
			});		
			
		});
		 
		
		$(".selectAllPageRecordContainer").remove();
		$("#select_all").attr('checked', false);
		$(".loading_container").hide();
		tableTopScrollbar();
		$(".ellipsis").ellipsis();

		pageTotalRecord=oSettings.json.data.length;
		allPageTotalRecord=oSettings.json.recordsTotal;

		// console.log(oSettings.json.message)

		if(oSettings.json.status == "false" && oSettings.json.recordsTotal == 0){
			$('#edit_error_modal .modal_title').html(oSettings.json.message);
			$('#edit_error_modal').modal('show');
		}

		// leon 2017.03.23
		$(function(){
			$("#adgroups-table").colResizable({resizeMode:'overflow'});
		});


    },
    "fnFooterCallback": function (nFoot, aData, mData, iStart, iEnd, aiDisplay) {

    	 var response = this.api().ajax.json();

    	 // console.log(response);

    	 nFoot.getElementsByTagName('th')[0].innerHTML = "Total of all "+response.total_count.toLocaleString('en')+" ads";
    	 nFoot.getElementsByTagName('th')[3].innerHTML = accounting.formatNumber(response.total[4]);
    	 nFoot.getElementsByTagName('th')[4].innerHTML = accounting.formatNumber(response.total[5]);
    	 nFoot.getElementsByTagName('th')[5].innerHTML = accounting.formatNumber(response.total[6],2)+"%";
    	 nFoot.getElementsByTagName('th')[6].innerHTML = accounting.formatNumber(response.total[7],2);
    	 nFoot.getElementsByTagName('th')[7].innerHTML = accounting.formatNumber(response.total[8],2);
    	 nFoot.getElementsByTagName('th')[8].innerHTML = accounting.formatNumber(response.total[9]);
    	 nFoot.getElementsByTagName('th')[9].innerHTML = accounting.formatNumber(response.total[10],2)+"%";
    	 nFoot.getElementsByTagName('th')[10].innerHTML = accounting.formatNumber(response.total[11],2);
    	 nFoot.getElementsByTagName('th')[11].innerHTML = accounting.formatNumber(response.total[12]);



    },

	"columnDefs": [
        {
            "render": function ( data, type, row ) {

            	var title_text = ""
            	title_text = row[2] + "(" + row[3].substr(0,15) + "...)"
                return '<div class="text-left checkbox"><label><input type="checkbox" name="id[]" value="'+row[0]+'|'+title_text+'">'+data+'</label></div>';
            },
            "targets": [1]
        },

        {
            "render": function ( data, type, row ) {
                return '<div class="text-left"><a href="'+row[19]+'">'+data+'</a></div>';
            },
            "targets": [2]
        },

        {
            "render": function ( data, type, row ) {
            	var link_text = ""
            	if(data != ""){
            		link_text = data.substr(0,25) + "..."

            		if(data.includes('http://') == false){
            			data = "http://"+data;
            		}

            	}
                return '<div class="text-left" style="width:200px;"><a target="_blank" href="'+data+'" title="'+data+'">'+ link_text +'</a></div>';
            },
            "targets": [15,17]
        },

        {
            "render": function ( data, type, row ) {
            	var link_text = ""
            	if(data != ""){
            		link_text = data.substr(0,25) + "..."

            		if(data.includes('http://') == false){
            			data = "http://"+data;
            		}

            	}
            	if(row[20] != 200 && row[20] != 0){
            		return '<div class="text-left" style="width:200px;"><a style="color:red;" target="_blank" href="'+data+'" title="'+data+'">'+ link_text +'</a></div>';
            	}else{
            		return '<div class="text-left" style="width:200px;"><a target="_blank" href="'+data+'" title="'+data+'">'+ link_text +'</a></div>';
            	}

            },
            "targets": [16]
        },

        {
            "render": function ( data, type, row ) {
            	var link_text = ""
            	if(data != ""){
            		link_text = data.substr(0,25) + "..."

            		if(data.includes('http://') == false){
            			data = "http://"+data;
            		}

            	}
            	if(row[21] != 200 && row[21] != 0){
                	return '<div class="text-left" style="width:200px;"><a style="color:red;" target="_blank" href="'+data+'" title="'+data+'">'+ link_text +'</a></div>';
                }else{
                	return '<div class="text-left" style="width:200px;"><a target="_blank" href="'+data+'" title="'+data+'">'+ link_text +'</a></div>';
                }
            },
            "targets": [18]
        },

        {
            "render": function ( data, type, row ) {
            	var html = '';
            	var link_text = "";
            	var link = row[15];
            	if(data != ""){
            		link_text = data.substr(0,25) + "..."

            		if(link.includes('http://') == false){
            			link = "http://"+link;
            		}
            	}
            	html+= '<div class="text-left" style="width:200px;">';
            	html+= '<div class="ellipsis" style="height: 20px;"><a target="_blank" href="'+link+'" title="'+data+'">'+link_text+'</a></div>';
            	html+= '<div class="ellipsis" style="height: 20px;">'+row[13]+'</div>';
            	html+= '<div class="ellipsis" style="height: 20px;">'+row[14]+'</div>';
            	html+= '<div class="ellipsis" style="height: 20px;color:#006621;">'+row[15]+'</div>';
            	html+= '</div>';

                return html;
            },
            "targets": [3]
        },
        {
            "render": function ( data, type, row ) {
                return '<div class="text-left">'+ data +'</div>';
            },
            "targets": [2]
        },
        {
            "render": function ( data, type, row ) {
                return '<div class="text-left" style="white-space: nowrap;">'+ data +'</div>';
            },
            "targets": [14,13]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data);
            },
            "targets": [4,5]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2);
            },
            // "targets": [11,12,16,19,20,21,22,23,24]
            "targets": [7,8,11]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2)+"%";
            },
            "targets": [6,10]
        },
        { "visible": false,  "targets": [ 0,19,20,21 ] },
        { "orderable": false, "targets": [1]}
    ],
    "order": [[ 4, "desc" ]],
    "aoColumns": aoColumns
};

var adsTable;

$(document).ready(function(){
	adsTable = $("#ads-table").on('preXhr.dt', function(e,settings,data){
		$('.selectAllPageRecordContainer').remove();
		$(".loading_container").show();
		$("#select_all").prop('checked', false);
	}).DataTable(adsTableOption);

	$("th").on("click selectstart", "input[type=checkbox]", function(e){
		e.stopPropagation();
	});

	// console.log(adsTable.fnCallback);
	// console.log(adsTable["context"]);
	// console.log(adsTable["context"][0]);
	// console.log(adsTable["context"][0]._iRecordsDisplay);

});

function getCampaignData(){
	adsTable.draw();
}
