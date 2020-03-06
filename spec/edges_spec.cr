require "./spec_helper"

describe CGL do
  describe "edges" do
    describe "equality" do
      it "of (u,v) should be equal to (v,u)" do
        CGL::Edge(String).new("a", "b").should eq(CGL::Edge(String).new("b", "a"))
        CGL::WEdge(String, Int32).new("a", "b", 1).should eq(CGL::WEdge(String, Int32).new("b", "a", 1))
        CGL::LEdge(String, Char).new("a", "b", '😀').should eq(CGL::LEdge(String, Char).new("b", "a", '😀'))
      end

      it "of two (u,v) should be true" do
        CGL::Edge(String).new("a", "b").should eq(CGL::Edge(String).new("a", "b"))
        CGL::WEdge(String, Int32).new("a", "b", 1).should eq(CGL::WEdge(String, Int32).new("a", "b", 1))
        CGL::LEdge(String, Char).new("a", "b", '😀').should eq(CGL::LEdge(String, Char).new("a", "b", '😀'))
      end
    end

    describe "hash" do
      it "of (u,v) should be equal to hash of (v,u)" do
        CGL::Edge(String).new("a", "b").hash.should eq(CGL::Edge(String).new("b", "a").hash)
        CGL::WEdge(String, Int32).new("a", "b", 1).hash.should eq(CGL::WEdge(String, Int32).new("b", "a", 1).hash)
        CGL::LEdge(String, Char).new("a", "b", '😀').hash.should eq(CGL::LEdge(String, Char).new("b", "a", '😀').hash)
      end

      it "of (u,v) should be equal to hash of (u,v)" do
        CGL::Edge(String).new("a", "b").hash.should eq(CGL::Edge(String).new("a", "b").hash)
        CGL::WEdge(String, Int32).new("a", "b", 1).hash.should eq(CGL::WEdge(String, Int32).new("a", "b", 1).hash)
        CGL::LEdge(String, Char).new("a", "b", '😀').hash.should eq(CGL::LEdge(String, Char).new("a", "b", '😀').hash)
      end
    end
  end

  describe "directed edges" do
    describe "equality" do
      it "of (u,v) should not be equal to (v,u)" do
        CGL::DiEdge(String).new("a", "b").should_not eq(CGL::DiEdge(String).new("b", "a"))
        CGL::WDiEdge(String, Int32).new("a", "b", 1).should_not eq(CGL::WDiEdge(String, Int32).new("b", "a", 1))
        CGL::LDiEdge(String, Char).new("a", "b", '😀').should_not eq(CGL::LDiEdge(String, Char).new("b", "a", '😀'))
      end

      it "of two (u,v) should be true" do
        CGL::DiEdge(String).new("a", "b").should eq(CGL::DiEdge(String).new("a", "b"))
        CGL::WDiEdge(String, Int32).new("a", "b", 1).should eq(CGL::WDiEdge(String, Int32).new("a", "b", 1))
        CGL::LDiEdge(String, Char).new("a", "b", '😀').should eq(CGL::LDiEdge(String, Char).new("a", "b", '😀'))
      end
    end

    describe "hash" do
      it "of (u,v) should not be equal to hash of (v,u)" do
        CGL::DiEdge(String).new("a", "b").hash.should_not eq(CGL::DiEdge(String).new("b", "a").hash)
        CGL::WDiEdge(String, Int32).new("a", "b", 1).hash.should_not eq(CGL::WDiEdge(String, Int32).new("b", "a", 1).hash)
        CGL::LDiEdge(String, Char).new("a", "b", '😀').hash.should_not eq(CGL::LDiEdge(String, Char).new("b", "a", '😀').hash)
      end

      it "of (u,v) should be equal to hash of (u,v)" do
        CGL::DiEdge(String).new("a", "b").hash.should eq(CGL::DiEdge(String).new("a", "b").hash)
        CGL::WDiEdge(String, Int32).new("a", "b", 1).hash.should eq(CGL::WDiEdge(String, Int32).new("a", "b", 1).hash)
        CGL::LDiEdge(String, Char).new("a", "b", '😀').hash.should eq(CGL::LDiEdge(String, Char).new("a", "b", '😀').hash)
      end
    end
  end

  describe "weighted edges" do
    describe "equality" do
      describe "with unweighted edges" do
        it "(u,v,1) should equal (u,v)" do
          CGL::WDiEdge(String, Int32).new("a", "b", 1).should eq(CGL::DiEdge(String).new("a", "b"))
          CGL::WDiEdge(String, Int32).new("a", "b", 1).should_not eq(CGL::DiEdge(String).new("b", "a"))
          CGL::WEdge(String, Int32).new("a", "b", 1).should eq(CGL::Edge(String).new("a", "b"))
          CGL::WEdge(String, Int32).new("a", "b", 1).should eq(CGL::Edge(String).new("b", "a"))
        end
      end

      describe "with weighted edges" do
        it "(u,v,1) should equal (u,v,1)" do
          CGL::WDiEdge(String, Int32).new("a", "b", 1).should eq(CGL::WDiEdge(String, Int32).new("a", "b", 1))
          CGL::WDiEdge(String, Int32).new("a", "b", 1).should_not eq(CGL::WDiEdge(String, Int32).new("b", "a", 1))
          CGL::WEdge(String, Int32).new("a", "b", 1).should eq(CGL::WEdge(String, Int32).new("a", "b", 1))
          CGL::WEdge(String, Int32).new("a", "b", 1).should eq(CGL::WEdge(String, Int32).new("b", "a", 1))
        end

        it "(u,v,1) should not eq (u,v,2)" do
          CGL::WDiEdge(String, Int32).new("a", "b", 1).should_not eq(CGL::WDiEdge(String, Int32).new("a", "b", 2))
          CGL::WDiEdge(String, Int32).new("a", "b", 1).should_not eq(CGL::WDiEdge(String, Int32).new("b", "a", 2))
          CGL::WEdge(String, Int32).new("a", "b", 1).should_not eq(CGL::WEdge(String, Int32).new("a", "b", 2))
          CGL::WEdge(String, Int32).new("a", "b", 1).should_not eq(CGL::WEdge(String, Int32).new("b", "a", 2))
        end
      end
    end
  end

  describe "labeled edges" do
    describe "equality" do
      describe "with unweighted edges" do
        it "(u,v,l) should equal (u,v)" do
          CGL::LDiEdge(String, Char).new("a", "b", '😀').should eq(CGL::DiEdge(String).new("a", "b"))
          CGL::LDiEdge(String, Char).new("a", "b", '😀').should_not eq(CGL::DiEdge(String).new("b", "a"))
          CGL::LEdge(String, Char).new("a", "b", '😀').should eq(CGL::Edge(String).new("a", "b"))
          CGL::LEdge(String, Char).new("a", "b", '😀').should eq(CGL::Edge(String).new("b", "a"))
        end
      end

      describe "with weighted edges" do
        it "(u,v,l1) should equal (u,v,l1)" do
          CGL::LDiEdge(String, Char).new("a", "b", '😀').should eq(CGL::LDiEdge(String, Char).new("a", "b", '😀'))
          CGL::LDiEdge(String, Char).new("a", "b", '😀').should_not eq(CGL::LDiEdge(String, Char).new("b", "a", '😀'))
          CGL::LEdge(String, Char).new("a", "b", '😀').should eq(CGL::LEdge(String, Char).new("a", "b", '😀'))
          CGL::LEdge(String, Char).new("a", "b", '😀').should eq(CGL::LEdge(String, Char).new("b", "a", '😀'))
        end

        it "(u,v,l1) should not eq (u,v,l2)" do
          CGL::LDiEdge(String, Char).new("a", "b", '😀').should_not eq(CGL::LDiEdge(String, Char).new("a", "b", '👹'))
          CGL::LDiEdge(String, Char).new("a", "b", '😀').should_not eq(CGL::LDiEdge(String, Char).new("b", "a", '👹'))
          CGL::LEdge(String, Char).new("a", "b", '😀').should_not eq(CGL::LEdge(String, Char).new("a", "b", '👹'))
          CGL::LEdge(String, Char).new("a", "b", '😀').should_not eq(CGL::LEdge(String, Char).new("b", "a", '👹'))
        end
      end
    end
  end
end
