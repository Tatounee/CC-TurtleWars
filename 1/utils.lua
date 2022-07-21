
-- Garde seulement les élements de la table `tbl` dont le predica `predicate(idx, value)` est vrai
function table.iretain(tbl, predicate)
	local rejected = {}
	for idx, value in ipairs(tbl) do
		if not predicate(idx, value) then
			table.insert(rejected, idx)
		end
	end

	for _, idx in ipairs(rejected) do
        table.remove(tbl, idx)
	end
end