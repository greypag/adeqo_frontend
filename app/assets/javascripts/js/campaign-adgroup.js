/**
 * @author elee
 */

exportUrl = campaignAdgroupGetUrl;

editSogouUrl=campaignAdgroupSogouUpdateUrl;
editThreesixtiesUrl=campaignAdgroupThreesixtiesUpdateUrl;
editBaiduUrl=campaignAdgroupBaiduUpdateUrl;
editShenmaUrl=campaignAdgroupShenmaUpdateUrl;

var aoColumns = [];
for(var i=0;i<21;i++){
	// aoColumns.push({ "asSorting": [ "desc", "asc" ] });
}


$('#adgroups-table thead tr th').each(function() {
	
	var show_class = $(this).attr("class");
	
	if (show_class != null && show_class.indexOf("js-sort-show") >= 0){
		aoColumns.push({ "asSorting": [ "desc", "asc" ] });	
	}
	
})

var adgroupTableOption = {
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
			d.csv=0;

			exportData=d;

			return d;
		}
	},
	"fnDrawCallback": function( oSettings ) {
		
		
		var response = this.api().ajax.json();
		var all_conversion_business_type = response.all_conversion_business_type;
		var return_conversion_array_total = response.return_conversion_array_total;

		
		
		$.each(return_conversion_array_total, function(key,valueObj){
			$('#'+key+"_total").replaceWith('<th class="'+key+'" id="'+key+'_total">'+accounting.formatNumber(valueObj,2)+'</th>');
		});
		
		
		
		$('#adgroups-table thead tr th').each(function(index ) {
       		
       		th_this = $(this);
       		
       		class_str = th_this.attr('class');
       		class_str_arr = class_str.split(" ");
       		
       		// console.log(class_str +" _ "+index);
       		
       		class_str_arr.forEach(function(class_str_arr_d) {
       			correct_html_index = index + 1
				if(all_conversion_business_type.includes(class_str_arr_d)){
	       			// console.log("sad_ "+index+"_"+class_str_arr_d);
					$('#adgroups-table tbody td:nth-child('+correct_html_index+')').addClass(class_str_arr_d);	       			
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

		pageTotalRecord=oSettings.json.data.length;
		allPageTotalRecord=oSettings.json.recordsTotal;

		//leon start 170328
           $("#adgroups-table").colResizable({
               partialRefresh: true,
							 liveDrag: true,
               resizeMode: 'overflow'
           });
           //leon end 170328
    },
    "fnFooterCallback": function (nFoot, aData, mData, iStart, iEnd, aiDisplay) {

    	 var response = this.api().ajax.json();

    	 // console.log(response);

    	 nFoot.getElementsByTagName('th')[0].innerHTML = "Total of all "+response.total_count.toLocaleString('en')+" ad groups";
    	 nFoot.getElementsByTagName('th')[3].innerHTML = accounting.formatNumber(response.total[4]);
    	 nFoot.getElementsByTagName('th')[4].innerHTML = accounting.formatNumber(response.total[5]);
    	 nFoot.getElementsByTagName('th')[5].innerHTML = accounting.formatNumber(response.total[6],2)+"%";
    	 nFoot.getElementsByTagName('th')[6].innerHTML = accounting.formatNumber(response.total[7],2);
    	 nFoot.getElementsByTagName('th')[7].innerHTML = accounting.formatNumber(response.total[8],2);
    	 nFoot.getElementsByTagName('th')[8].innerHTML = accounting.formatNumber(response.total[9]);
    	 nFoot.getElementsByTagName('th')[9].innerHTML = accounting.formatNumber(response.total[10],2)+"%";
    	 nFoot.getElementsByTagName('th')[10].innerHTML = accounting.formatNumber(response.total[11],2);
    	 nFoot.getElementsByTagName('th')[11].innerHTML = accounting.formatNumber(response.total[12],2);
    	 nFoot.getElementsByTagName('th')[12].innerHTML = accounting.formatNumber(response.total[13],2);
    	 nFoot.getElementsByTagName('th')[13].innerHTML = accounting.formatNumber(response.total[14],2);
    	 nFoot.getElementsByTagName('th')[14].innerHTML = accounting.formatNumber(response.total[15],2);
    	 nFoot.getElementsByTagName('th')[15].innerHTML = accounting.formatNumber(response.total[16],2)+"%";


    },
	"columnDefs": [
        {
            "render": function ( data, type, row ) {

                if(row[18] == 0 && row[19] == 0){
                	return '<div class="text-left checkbox"><label><input type="checkbox" name="id[]" value="'+row[0]+'|'+row[2]+'">'+data+'</label></div>';
                }else{
            		return '<div class="text-left checkbox"><img style="margin-right:8px;" width="22" src="/images/icon/loading-x.gif">'+data+'</div>';
            	}



            },
            "targets": [1]
        },

        {
            "render": function ( data, type, row ) {
                return '<div class="text-left"><a href="'+row[17]+'">'+data+'</a></div>';
            },
            "targets": [2]
        },

        {
            "render": function ( data, type, row ) {
                return '<div class="text-left">'+ data +'</div>';
            },
            "targets": [2]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data);
            },
            "targets": [4,5,9]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2);
            },
            "targets": [3,7,8,11,12,13,14,15]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2)+"%";
            },
            "targets": [6,10,16]
        },
        { "visible": false,  "targets": [ 0,17,18,19 ] },
        { "orderable": false, "targets": [1,18,19]}
    ],
    "order": [[ 4, "desc" ]],
    "aoColumns": aoColumns
};

var adgroupTable;

$(document).ready(function(){
	adgroupTable = $("#adgroups-table").on('preXhr.dt', function(e,settings,data){
		$(".loading_container").show();
	}).DataTable(adgroupTableOption);

	$("th").on("click selectstart", "input[type=checkbox]", function(e){
		e.stopPropagation();
	});
});

function getCampaignData(){
	adgroupTable.draw();
}
