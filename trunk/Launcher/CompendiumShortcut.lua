import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common";

CompendiumShortcut = class( Turbine.UI.Window );

function CompendiumShortcut:Constructor()
	Turbine.UI.Window.Constructor( self );

	self:SetPosition(tostring(Turbine.UI.Display.GetWidth()-55),230);	
	self:SetSize(35,35);
	self:SetZOrder(109);	
	self:SetVisible( true );
	--self:SetOpacity(1);
	--self:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	--self:SetBackColor( Turbine.UI.Color(0,0,0,0) );
	
	self.button = Turbine.UI.Control();
	self.button:SetParent(self);
	self.button:SetPosition(0,0);
	self.button:SetSize(35,35);
	self.button:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	self.button:SetBackground("Compendium/Common/Resources/images/icon.tga");
	
	self.ShortcutClick = function() end
	self.ShortcutMoved = function(left, top) end

	self.button.MouseEnter = function(sender,args)
		self.button:SetBackground("Compendium/Common/Resources/images/icon-highlight.tga");
	end
	self.button.MouseLeave = function(sender,args)
		self.button:SetBackground("Compendium/Common/Resources/images/icon.tga");
	end		
	self.button.MouseDown = function( sender, args )
		if(args.Button == Turbine.UI.MouseButton.Left) then
			sender.dragStartX = args.X;
			sender.dragStartY = args.Y;
			sender.dragging = true;
			sender.dragged = false;
			--self:SetBackColor( Turbine.UI.Color(0,0,1,0) );
		end
	end
	self.button.MouseUp = function( sender, args )
		if(args.Button == Turbine.UI.MouseButton.Left) then
			if (sender.dragging) then
				sender.dragging = false;
			end
			if not sender.dragged then
				self.ShortcutClick();
			else 
				self.ShortcutMoved( self:GetLeft(), self:GetTop());
			end
			--self:SetBackColor( Turbine.UI.Color(0,0,0,0) );
		end
	end
	self.button.MouseMove = function(sender,args)
		if ( sender.dragging ) then
			local left, top = self:GetPosition();
			self:SetPosition( left + ( args.X - sender.dragStartX ), top + args.Y - sender.dragStartY );
			sender:SetPosition( 0, 0 );
			sender.dragged = true;
		end
	end
end
