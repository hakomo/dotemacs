
s=open("snippet.cpp").read

i=0
loop{
  i=s.index("//snippet-begin",i)
  break if !i
  j=s.index("\n//snippet-end",i)
  k=s.index("\"",i)
  open(s[(k+1)...s.index("\"",k+1)],"w").write(s[(s.index("\n",i)+1)...j])
  i+=1
}

i=0
loop{
  i=s.index("//snippet-begin",i)
  break if !i
  j=s.index("\n",i)
  k=s.index("//snippet-end",i)
  if s[i..j].include?("snippet-only")
    s[i..(k+14)]=""
  else
    s[i..j]=s[k,14]=""
  end
}

open("hlib.hpp","w").write(s)
