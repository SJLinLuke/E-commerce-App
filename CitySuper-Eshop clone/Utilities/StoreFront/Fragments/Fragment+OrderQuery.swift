//
//  Fragment+OrderQuery.swift
//  CitySuper-Eshop clone
//
//  Created by LukeLin on 2024/5/28.
//

import Foundation
import MobileBuySDK

extension Storefront.OrderQuery {
    
    @discardableResult
    func fragmentForStandardOrderNode() -> Storefront.OrderQuery {return self
            .id()
            .orderNumber()
            .email()
            .totalPrice { $0
                .amount()
                .currencyCode()
            }
            .originalTotalDuties { $0
                .amount()
                .currencyCode()
            }
            .currentTotalDuties { $0
                .amount()
                .currencyCode()
            }
            .totalShippingPrice({ $0
                .amount()
                .currencyCode()
            })
            .shippingAddress({ $0
                .id()
                .firstName()
                .lastName()
                .phone()
                .address1()
                .address2()
                .city()
                .country()
                .countryCodeV2()
                .province()
                .provinceCode()
                .zip()
            })
            .processedAt()
            .financialStatus()
            .fulfillmentStatus()
            .lineItems(first: 25) { $0
                .nodes { $0
                    .title()
                    .quantity()
                    .currentQuantity()
                    .originalTotalPrice {
                        $0.amount()
                    }
                    .variant { $0
                        .id()
                        .title()
                        .image { $0
                            .url()
                        }
                        .compareAtPrice{ $0
                            .amount()
                        }
                        .quantityAvailable()
                        .price { $0
                            .amount()
                            .currencyCode()
                        }
                        .product{ $0
                            .id()
                            .title()
                        }
                    }
                }
            }
            .discountApplications(first: 250) { $0
                .edges { $0
                    .node { $0
                        .fragmentForDiscountApplication()
                    }
                }
            }
    }
}
