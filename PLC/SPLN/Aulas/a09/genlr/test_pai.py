import genlr

g = genlr.importGen("jj.yaml")
#print(genlr.pai("Ijj",g))

def test_pai():
  assert genlr.pai("Ijj",g) == "Duarte PDA"
