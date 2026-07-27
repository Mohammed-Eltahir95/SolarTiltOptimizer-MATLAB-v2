function Ed = transposeDiffuse(model,betaGrid,c)
%TRANSPOSEDIFFUSE Eight equations preserved from the original script.
beta=betaGrid';
switch lower(model)
    case 'liujordan', Ed=c.DHI.*c.Fd;
    case 'badescu', Ed=c.DHI.*((3+cosd(2*beta))/4);
    case 'koronakis', Ed=c.DHI.*((2+cosd(beta))/3);
    case 'klucher'
        F=min(max(1-(c.DHI./max(c.GHI,1e-6)).^2,0),1);
        Ed=c.DHI.*(c.Fd.*(1+F.*sind(beta/2).^3)).*(1+F.*c.cosInc.^2.*sind(c.zen).^3);
    case 'haydavies'
        Rb=max(c.cosInc./max(c.cosZ,1e-6),0); Ed=c.DHI.*(c.AI.*Rb+(1-c.AI).*c.Fd);
    case 'hdkr'
        f=sqrt(max(c.BHI./max(c.GHI,1e-6),0)); Rb=max(c.cosInc./max(c.cosZ,1e-6),0);
        base=c.AI.*Rb+(1-c.AI).*c.Fd.*(1+f.*sind(beta/2).^3);
        Ed=c.DHI.*base.*(1+f.*c.cosInc.^2.*sind(c.zen).^3);
    case 'tempscoulson'
        Ed=c.DHI.*(c.Fd.*(1+sind(beta/2).^3)).*(1+c.cosInc.^2.*sind(c.zen).^3);
    case 'perez', Ed=perez(betaGrid,c.DHI,c.DNI,c.zen,c.E0,c.cosInc,c.cosZ);
    otherwise, error('SolarTilt:UnknownModel','Unknown model: %s',model)
end
Ed=max(Ed,0); Ed(~isfinite(Ed))=0;
end

function Ed=perez(betaGrid,DHI,DNI,zen,E0,cosInc,cosZ)
beta=betaGrid'; a=max(0,cosInc); b=max(cosd(85),max(cosZ,1e-6));
z=min(max(zen,0),89.9); AM=1./(cosd(z)+0.50572*((96.07995-z).^(-1.6364)));
zclip=min(max(zen,0),89.999); zrad=deg2rad(zclip);
epsC=((DHI+DNI)./max(1e-6,DHI)+1.041*zrad.^3)./(1+1.041*zrad.^3);
delta=DHI.*AM./max(1e-6,E0);
edges=[1 1.065 1.230 1.500 1.950 2.800 4.500 6.200 Inf];
C=[-.008 .588 -.062 -.060 .072 -.022;.130 .683 -.151 -.019 .066 -.029;.330 .487 -.221 .055 -.064 -.026;.568 .187 -.295 .109 -.152 -.014;.873 -.392 -.362 .226 -.462 .001;1.132 -1.237 -.412 .288 -.823 .056;1.060 -1.600 -.359 .264 -1.127 .131;.678 -.327 -.250 .156 -1.377 .251];
bin=ones(numel(zen),1); for k=1:8, bin(epsC>=edges(k)&epsC<edges(k+1))=k; end
F1=zeros(size(zen)); F2=F1;
for k=1:8, q=bin==k; F1(q)=max(0,C(k,1)+C(k,2).*delta(q)+C(k,3).*zen(q)); F2(q)=C(k,4)+C(k,5).*delta(q)+C(k,6).*zen(q); end
Ed=DHI.*max(0,(1-F1).*(1+cosd(beta))/2+F1.*(a./b)+F2.*sind(beta));
end

