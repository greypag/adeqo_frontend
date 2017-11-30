/**
 * @author elee
 */

exportUrl = campaignKeywordGetUrl;

editSogouUrl=campaignKeywordSogouUpdateUrl;
editThreesixtiesUrl=campaignKeywordThreesixtiesUpdateUrl;
editBaiduUrl=campaignKeywordBaiduUpdateUrl;
editShenmaUrl=campaignKeywordShenmaUpdateUrl;

var aoColumns = [];
for(var i=0;i<28;i++){
	// aoColumns.push({ "asSorting": [ "desc", "asc" ] });
}


$('#keywords-table thead tr th').each(function() {
	
	var show_class = $(this).attr("class");
	
	if (show_class != null && show_class.indexOf("js-sort-show") >= 0){
		aoColumns.push({ "asSorting": [ "desc", "asc" ] });	
	}
	
})

var keywordTableOption = {
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
		}
	},
	"fnDrawCallback": function( oSettings ) {

		var response = this.api().ajax.json();
		var all_conversion_business_type = response.all_conversion_business_type;
		var return_conversion_array_total = response.return_conversion_array_total;
		
		
		$.each(return_conversion_array_total, function(key,valueObj){
			$('#'+key+"_total").replaceWith('<th class="'+key+'" id="'+key+'_total">'+accounting.formatNumber(valueObj,2)+'</th>');
		});
		
		
		$('#keywords-table thead tr th').each(function(index ) {
       		
       		th_this = $(this);
       		
       		class_str = th_this.attr('class');
       		class_str_arr = class_str.split(" ");
       		
       		// console.log(class_str +" _ "+index);
       		
       		class_str_arr.forEach(function(class_str_arr_d) {
       			correct_html_index = index + 1
				if(all_conversion_business_type.includes(class_str_arr_d)){
	       			// console.log("sad_ "+index+"_"+class_str_arr_d);
					$('#keywords-table tbody td:nth-child('+correct_html_index+')').addClass(class_str_arr_d);	       			
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

		if(oSettings.json.status == "false" && oSettings.json.recordsTotal == 0){
			$('#edit_error_modal .modal_title').html(oSettings.json.message);
			$('#edit_error_modal').modal('show');
		}







		$('#keywords-table tbody td.edit').editable(function(value, settings) {


			// console.log($(this).attr('class'));
		    // console.log(value);
		    // console.log(this.revert);
		    // console.log(settings);

		    // console.log(id);
		    if(value == this.revert){
		    	return(parseFloat(value).toFixed(2));
		    }



		    var all_class = $(this).attr('class');
		    var all_class_arr = all_class.split(' ')

		    var keyword_id = "";

		    for(var i=0; i< all_class_arr.length; i++) {
		    	if(all_class_arr[i].indexOf("id") >= 0 ){
		    		keyword_id = all_class_arr[i].replace("id", "");
		    	}
			}

			// console.log(keyword_id);

		    var campaign_type = $("#campaign_type").val();
		    var campaign_id = $("#campaign_id").val();
		    var network_id = $("#network_id").val();

		    // console.log(campaign_type);
		    // console.log(campaign_id);
		    // console.log(network_id);

		    $.ajax({
					url: "/quickedit/keyword",
					type: 'POST',
					data: "network_type="+campaign_type+"&network_id="+network_id+"&campaign_id="+campaign_id+"&keyword_id="+keyword_id+"&cpc="+value,
					success: function(data,status,xhr){
						$(".loading_container").hide();
						// $(this).remove();
						console.log(data.status);

						if(data.status == "true"){
							// location.reload();
							// $('#status'+id).text("Cancel")
							// $('#edit_error_modal .modal_title').html("CPC Updated.");
							// $('#edit_error_modal').modal('show');
						}else if(data.status=='test'){
						}else{
							$('#edit_error_modal .modal_title').html(data.message);
							$('#edit_error_modal').modal('show');
						}
					},
					error: function(xhr,status,error){

						$('#edit_error_modal .modal_title').html("Your request is invalid.");
						$('#edit_error_modal').modal('show');

						console.log(xhr);
						console.log(error);
						// alert(error);
					}
			});

		    return(parseFloat(value).toFixed(2));
		}, {
			type : 'text',
			// cancel : 'Cancel',
			// submit : 'Submit',
			event  : 'click',
			select : true,
			onblur : function() {
				$("#keywords-table tbody td.edit").find("form").submit();
			},
			// indicator : 'Saving...'
         	tooltip   : 'Click to edit...'
		});

		//leon start 170328
           $("#keywords-table").colResizable({
               partialRefresh: true,
							 liveDrag: true,
               resizeMode: 'overflow'
           });
           //leon end 170328

    },
    "fnCreatedRow": function( nRow, aData, iDataIndex ) {
      // Bold the grade for all 'A' grade browsers

      // console.log("sadwahahahahahaha");
      // // console.log(nRow[7]);
      // console.log(aData[7]);
      // console.log("wahahahahahaha");
//
      // $('td:eq(7)', nRow).html( '<b>A</b>' );
      $('td:eq(6)', nRow).addClass( 'edit' );
      $('td:eq(6)', nRow).addClass( 'id'+aData[0] );

      // $('td:eq(6)', nRow).attr('id', 'foo123');
    },
    "fnFooterCallback": function (nFoot, aData, mData, iStart, iEnd, aiDisplay) {

    	 var response = this.api().ajax.json();

    	 console.log(response);
    	 console.log(response.total);
    	 console.log(response.total_count);

    	 if(response.total_count > 0){
	    	 nFoot.getElementsByTagName('th')[0].innerHTML = "Total of all "+response.total_count+" keywords";
	    	 // nFoot.getElementsByTagName('th')[6].innerHTML = accounting.formatNumber(response.total[7],2);
	    	 nFoot.getElementsByTagName('th')[7].innerHTML = accounting.formatNumber(response.total[8]);
	    	 nFoot.getElementsByTagName('th')[8].innerHTML = accounting.formatNumber(response.total[9]);
	    	 nFoot.getElementsByTagName('th')[9].innerHTML = accounting.formatNumber(response.total[10],2)+"%";
	    	 nFoot.getElementsByTagName('th')[10].innerHTML = accounting.formatNumber(response.total[11],2);
	    	 nFoot.getElementsByTagName('th')[11].innerHTML = accounting.formatNumber(response.total[12],2);
	    	 nFoot.getElementsByTagName('th')[12].innerHTML = accounting.formatNumber(response.total[13]);

	    	 nFoot.getElementsByTagName('th')[13].innerHTML = accounting.formatNumber(response.total[14],2)+"%";
	    	 nFoot.getElementsByTagName('th')[14].innerHTML = accounting.formatNumber(response.total[15],2);
	    	 nFoot.getElementsByTagName('th')[15].innerHTML = accounting.formatNumber(response.total[16],2);
	    	 nFoot.getElementsByTagName('th')[16].innerHTML = accounting.formatNumber(response.total[17],2);
	    	 nFoot.getElementsByTagName('th')[17].innerHTML = accounting.formatNumber(response.total[18],2);
	    	 nFoot.getElementsByTagName('th')[18].innerHTML = accounting.formatNumber(response.total[19],2);
	    	 nFoot.getElementsByTagName('th')[19].innerHTML = accounting.formatNumber(response.total[20],2);
	    	 nFoot.getElementsByTagName('th')[20].innerHTML = accounting.formatNumber(response.total[21],2)+"%";
    	 }

    },
	"columnDefs": [
        {
            "render": function ( data, type, row ) {
                return '<div class="text-left checkbox"><label><input type="checkbox" name="id[]" value="'+row[0]+'|'+row[2]+'|'+row[3]+'">'+data+'</label></div>';
            },
            "targets": [1]
        },

        {
            "render": function ( data, type, row ) {
                return '<div class="text-left"><a href="'+row[24]+'">'+data+'</a></div>';
            },
            "targets": [2]
        },

        {
            "render": function ( data, type, row ) {
            	var link_text = ""
            	if(data != ""){
            		link_text = decodeURIComponent(data).substr(0,25) + "..."
            	}

            	if(row[25] != 200 && row[25] != 0){
                	return '<div class="text-left" style="width:200px;"><a style="color:red;" target="_blank" href="'+data+'" title="'+decodeURIComponent(data)+'">'+ link_text +'</a></div>';
                }else{
               		return '<div class="text-left" style="width:200px;"><a target="_blank" href="'+data+'" title="'+decodeURIComponent(data)+'">'+ link_text +'</a></div>';
                }

            },
            "targets": [5,22]
        },

        {
            "render": function ( data, type, row ) {
            	var link_text = ""
            	if(data != ""){
            		link_text = decodeURIComponent(data).substr(0,25) + "..."
            	}
            	if(row[26] != 200 && row[26] != 0){
                	return '<div class="text-left" style="width:200px;"><a style="color:red;" target="_blank" href="'+data+'" title="'+decodeURIComponent(data)+'">'+ link_text +'</a></div>';
                }else{
                	return '<div class="text-left" style="width:200px;"><a target="_blank" href="'+data+'" title="'+decodeURIComponent(data)+'">'+ link_text +'</a></div>';
                }
            },
            "targets": [6,23]
        },
        {
            "render": function ( data, type, row ) {
                return '<div class="text-left">'+ data +'</div>';
            },
            "targets": [2,3,4]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data);
            },
            "targets": [8,9,13]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2);
            },
            "targets": [7,11,12,15,16,17,18,19,20]
        },
        {
            "render": function ( data, type, row ) {
                return accounting.formatNumber(data,2)+"%";
            },
            "targets": [10,14,21]
        },
        { "visible": false,  "targets": [ 0,24,25,26 ] }
    ],
    "order": [[ 9, "desc" ]],
    "aoColumns": aoColumns
};

var keywordTable;

$(document).ready(function(){
	keywordTable = $("#keywords-table").on('preXhr.dt', function(e,settings,data){
		$(".loading_container").show();
		$("#select_all").prop('checked', false);
	}).DataTable(keywordTableOption);

	$("th").on("click selectstart", "input[type=checkbox]", function(e){
		e.stopPropagation();
	});
});

function getCampaignData(){
	keywordTable.draw();

}
