package org.toshiroioc.test.puremvc.view
{
	import mx.containers.Panel;
	import mx.controls.DataGrid;
	import mx.controls.Label;

	public class DynamicExampleView extends Panel
	{
		public var dynamic_view_grid : DataGrid;
		public var dynamic_view_lbl : Label;
		public var dynamic_view_lbl2 : Label;
		private var example : ExampleView;
		
		public function DynamicExampleView()
		{
			super();
			dynamic_view_grid = new DataGrid();
			addChild(dynamic_view_grid);
			dynamic_view_lbl = new Label();
			addChild(dynamic_view_lbl);
			dynamic_view_lbl2 = new Label();
			addChild(dynamic_view_lbl2);
			/* view_grid.percentWidth = 100;
			view_grid.percentHeight = 100;
			var column : DataGridColumn = new DataGridColumn("View Grid");
			view_grid.columns = [column]; */
			
		}
		
		
		public function set exampleView(value:ExampleView):void{
			example = value;
		}
		
		public function get exampleView():ExampleView{
			return example;
		}
		
	}
}

/* <mx:DataGrid id="view_grid" width="100%" height="100%">
		<mx:columns>
			<mx:DataGridColumn dataField="label" headerText="View Grid"/>
		</mx:columns>
	</mx:DataGrid>
	
	<mx:Label id="view_lbl" width="100%"  color="#125A69" fontWeight="bold" fontSize="14" alpha="1.0" textAlign="center"/> */