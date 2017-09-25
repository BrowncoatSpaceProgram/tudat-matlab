function epoch = dateToEpoch(date,referenceDate)

if ~isa(date,'datetime')
    date = datetime(date);
end

if nargin < 2
    referenceDate = '2000-01-01 12:00:00';  % J2000
elseif ~isa(referenceDate,'datetime')
    referenceDate = datetime(referenceDate);
end

epoch = convert.toSI(juliandate(date) - juliandate(referenceDate),'d');

end
