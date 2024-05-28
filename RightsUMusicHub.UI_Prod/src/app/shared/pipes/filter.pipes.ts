import { Pipe, PipeTransform } from '@angular/core';
import { HttpClient }          from '@angular/common/http';
@Pipe({
  name: 'filter'
})
export class FilterPipe implements PipeTransform {
  transform(items: any[], searchText: string): any[] {
    if(!items) return [];
    if(!searchText) return items;
searchText = searchText.toLowerCase();
return items.filter( it => {
  console.log(it);
      return it.PlaylistName.toLowerCase().includes(searchText);
      // return it.toString().toLowerCase().indexOf(searchText) > -1;
  
      
    });
   }
}

@Pipe({
  name: 'filtertitle'
})
export class FilterTitlePipe implements PipeTransform {
  transform(items: any[], searchText: string): any[] {
    if(!items) return [];
    if(!searchText) return items;
searchText = searchText.toLowerCase();
return items.filter( it => {
  // console.log(it);
      return it.Title_Name.toLowerCase().includes(searchText);
      // return it.toString().toLowerCase().indexOf(searchText) > -1;
  
      
    });
   }
}

