function storeResults(db,id,varargin)
if isempty(db),return,end
types={'annual','monthly','seasonal','statistics'};for k=1:numel(varargin),insert(db,'results',{'run_id','result_type','payload_json'},{char(id),types{k},jsonencode(table2struct(varargin{k}))});end
end

