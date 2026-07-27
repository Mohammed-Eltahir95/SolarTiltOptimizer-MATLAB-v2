function id=seasonId(monthNumber)
id=zeros(size(monthNumber)); id(ismember(monthNumber,[12 1 2]))=1;
id(ismember(monthNumber,[3 4 5]))=2; id(ismember(monthNumber,[6 7 8]))=3;
id(ismember(monthNumber,[9 10 11]))=4;
end

