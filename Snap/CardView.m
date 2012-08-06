//
//  CardView.m
//  Snap
//
//  Created by Jesper Nielsen on 03/08/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "CardView.h"
#import "Card.h"
#import "Player.h"

const CGFloat CardWidth = 67.0f;
const CGFloat CardHeight = 99.0f;

@implementation CardView{
    UIImageView *_backImageView;
    UIImageView *_frontImageView;
    CGFloat _angle;
}

@synthesize card = _card;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])){
        self.backgroundColor = [UIColor clearColor];
        [self loadBack];
    }
    return self;
}

- (void)loadBack{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.image = [UIImage imageNamed:@"Back"];
        _backImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backImageView];
    }
}

- (void)animateDealingToPlayer:(Player *)player withDelay:(NSTimeInterval)delay{
    self.frame = CGRectMake(-100.0f, -100.0f, CardWidth, CardHeight);
    self.transform = CGAffineTransformMakeRotation(M_PI);
    
    CGPoint point = [self centerForPlayer:player];
    _angle = [self angleForPlayer:player];
    
    [UIView animateWithDuration:0.2f delay:delay options:UIViewAnimationCurveEaseOut animations:^{
        self.center = point;
        self.transform = CGAffineTransformMakeRotation(_angle);
    }completion:nil];
}

- (void)animateTurningOverForPlayer:(Player *)player{
    [self loadFront];
    [self.superview bringSubviewToFront:self];
    
    UIImageView *darkenView = [[UIImageView alloc] initWithFrame:self.bounds];
    darkenView.backgroundColor = [UIColor clearColor];
    darkenView.image = [UIImage imageNamed:@"Darken"];
    darkenView.alpha = 0.0f;
    [self addSubview:darkenView];
    
    CGPoint startPoint = self.center;
    CGPoint endPoint = [self centerForPlayer:player];
    CGFloat afterAngle = [self angleForPlayer:player];
    
    CGPoint halfwayPoint = CGPointMake((startPoint.x - endPoint.x) / 2.0f, (startPoint.y - endPoint.y) / 2.0f);
    CGFloat halfwayAngle = (_angle + afterAngle) / 2.0f;
    
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
        CGRect rect = _backImageView.bounds;
        rect.size.width = 1.0f;
        _backImageView.bounds = rect;
        
        darkenView.bounds = rect;
        darkenView.alpha = 0.5;
        
        self.center = halfwayPoint;
        self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(halfwayAngle), 1.2f, 1.2f);
        
    }completion:^(BOOL finished){
        _frontImageView.bounds = _backImageView.bounds;
        _frontImageView.hidden = NO;
        
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect rect = _frontImageView.bounds;
            rect.size.width = CardWidth;
            _frontImageView.bounds = rect;
            
            darkenView.bounds = rect;
            darkenView.alpha = 0.0f;
            
            self.center = endPoint;
            self.transform = CGAffineTransformMakeRotation(afterAngle);
        }completion:^(BOOL finished){
            [darkenView removeFromSuperview];
            [self unloadBack];
        }];
    }];
}

- (CGPoint)centerForPlayer:(Player *)player{
    CGRect rect = self.superview.bounds;
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGFloat x = -3.0 + RANDOM_INT(6) + CardWidth/2.0f;
    CGFloat y = -3.0 + RANDOM_INT(6) + CardHeight/2.0f;
    
    if (self.card.isTurnedOver) {
        if (player.position == PlayerPositionBottom)
		{
			x += midX + 7.0f;
			y += maxY - CardHeight - 30.0f;
		}
		else if (player.position == PlayerPositionLeft)
		{
			x += 31.0f;
			y += midY - 30.0f;
		}
		else if (player.position == PlayerPositionTop)
		{
			x += midX - CardWidth - 7.0f;
			y += 29.0f;
		}
		else
		{
			x += maxX - CardHeight + 1.0f;
			y += midY - CardWidth - 45.0f;
		}
    } else {
        if (player.position == PlayerPositionBottom) {
            x += midX - CardWidth -7.0f;
            y += maxY - CardHeight - 30.0f;
        }
        else if (player.position == PlayerPositionLeft){
            x += 31.0f;
            y += midY - CardHeight - 45.0f;
        }
        else if (player.position == PlayerPositionTop){
            x += midX + 7.0f;
            y += 29.0f;
        }
        else {
            x += maxX - CardHeight + 1.0f;
            y += midY - 30.0f;
        }
    }
    
    
    return CGPointMake(x, y);
}

- (CGFloat)angleForPlayer:(Player *)player{
    float theAngle = (-0.5f + RANDOM_FLOAT()) / 4.0f;
    if (player.position == PlayerPositionLeft) {
        theAngle += M_PI / 2.0f;
    }
    else if (player.position == PlayerPositionTop){
        theAngle += M_PI;
    }
    else if (player.position == PlayerPositionRight){
        theAngle -= M_PI / 2.0f;
    }
    return theAngle;
}

- (void)loadFront{
    if (_frontImageView == nil) {
        _frontImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _frontImageView.contentMode = UIViewContentModeScaleToFill;
        _frontImageView.hidden = YES;
        [self addSubview:_frontImageView];
        
        NSString *suit;
        switch (self.card.suit) {
            case SuitClubs:
                suit = @"Clubs";
                break;
            case SuitDiamonds:
                suit = @"Diamonds";
                break;
            case SuitHearts:
                suit = @"Hearts";
                break;
            case SuitSpades:
                suit = @"Spades";
                break;
            default:
                break;
        }
        
        NSString *value;
        switch (self.card.value) {
            case CardAce:
                value = @"Ace";
                break;
            case CardKing:
                value = @"King";
                break;
            case CardQueen:
                value = @"Queen";
                break;
            case CardJack:
                value = @"Jack";
                break;
            default:
                value = [NSString stringWithFormat:@"%d", self.card.value];
                break;
        }
        NSString *fileName = [NSString stringWithFormat:@"%@ %@", suit, value];
        _frontImageView.image = [UIImage imageNamed:fileName];
    }
}

- (void)unloadBack{
    [_backImageView removeFromSuperview];
    _backImageView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
