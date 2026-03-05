# /components — React Native Component Pattern

Write React Native screens and components using the design system tokens and MVVM architecture.

## Architecture

```
src/modules/[feature]/
├── screens/
│   └── OrderDetail/
│       ├── OrderDetail.tsx            # View — pure presentation
│       ├── OrderDetail.viewModel.ts   # ViewModel — state + logic
│       └── OrderDetail.styles.ts      # Styles — StyleSheet.create
├── components/
│   └── OrderCard/
│       ├── OrderCard.tsx
│       └── OrderCard.styles.ts
└── hooks/
    └── useOrders.ts                   # React Query hook
```

## Design Tokens

**Never hardcode values.** Import from the design system:

```typescript
import { colors } from "@designSystem/colors";
import { fonts } from "@designSystem/fonts";
import { spaces } from "@designSystem/spaces";
import { borders } from "@designSystem/borders";
```

### Colors
```typescript
colors["color-text-primary"]       // main text
colors["color-text-secondary"]     // muted text
colors["color-background-primary"] // screen background
colors["color-background-card"]    // card surfaces
colors["color-border-default"]     // borders and dividers
colors["color-icon-primary"]       // icons
colors["color-background-btn"]     // button backgrounds
colors["color-text-success"]       // success states
colors["color-text-danger"]        // error states
```

### Fonts
```typescript
fonts.headlineLarge    // screen titles
fonts.headlineMedium   // section headers
fonts.bodyLarge        // main content
fonts.bodyMedium       // secondary content
fonts.labelMedium      // form labels
fonts.buttonMedium     // button text
```

### Spaces
```typescript
spaces.xxs   // 2    spaces.md    // 16    spaces.xxxl  // 48
spaces.xs    // 4    spaces.lg    // 20    spaces.xxxxl // 56
spaces.sm    // 8    spaces.xl    // 24
spaces.smd   // 12   spaces.xxl   // 32
```

## Component Library

Use built-in components before creating custom ones:

```typescript
import { Typography } from "@opal/Typography";
import { Button } from "@opal/Button";
import { Icon } from "@opal/Icon";
import { Input } from "@opal/Input";
```

### Button Variants
```typescript
<Button variant="brandPrimary" onPress={handleSubmit}>Confirmar</Button>
<Button variant="secondary" onPress={handleCancel}>Cancelar</Button>
<Button variant="destructive" onPress={handleDelete}>Eliminar</Button>
<Button variant="tertiary" icon="arrow-left" onPress={goBack} />
```

### Typography
```typescript
<Typography variant="headlineLarge">Order #1234</Typography>
<Typography variant="bodyMedium" color={colors["color-text-secondary"]}>
  Scheduled for tomorrow
</Typography>
```

## Template: Screen (View)

```typescript
// OrderDetail.tsx
import React from "react";
import { View, ScrollView } from "react-native";
import { Typography } from "@opal/Typography";
import { Button } from "@opal/Button";
import { useOrderDetailViewModel } from "./OrderDetail.viewModel";
import { styles } from "./OrderDetail.styles";

export const OrderDetail: React.FC = () => {
  const { order, isLoading, handleCancel } = useOrderDetailViewModel();

  if (isLoading) return <LoadingSpinner />;

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Typography variant="headlineLarge">{order.serviceName}</Typography>
        <Typography variant="bodyMedium" color={styles.mutedText.color}>
          {order.formattedDate}
        </Typography>
      </View>

      <View style={styles.actions}>
        <Button variant="destructive" onPress={handleCancel}>
          Cancelar reserva
        </Button>
      </View>
    </ScrollView>
  );
};
```

## Template: ViewModel

```typescript
// OrderDetail.viewModel.ts
import { useCallback } from "react";
import { useRoute } from "@react-navigation/native";
import { useOrder, useCancelOrder } from "../hooks/useOrders";

export const useOrderDetailViewModel = () => {
  const { params } = useRoute<OrderDetailRouteProp>();
  const { data: order, isLoading } = useOrder(params.orderId);
  const cancelMutation = useCancelOrder();

  const handleCancel = useCallback(() => {
    cancelMutation.mutate(params.orderId);
  }, [params.orderId]);

  return {
    order,
    isLoading,
    handleCancel,
    isCancelling: cancelMutation.isPending,
  };
};
```

## Template: Styles

```typescript
// OrderDetail.styles.ts
import { StyleSheet } from "react-native";
import { colors } from "@designSystem/colors";
import { fonts } from "@designSystem/fonts";
import { spaces } from "@designSystem/spaces";

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors["color-background-primary"],
    padding: spaces.lg,
  },
  header: {
    gap: spaces.xs,
    marginBottom: spaces.xl,
  },
  mutedText: {
    color: colors["color-text-secondary"],
  },
  actions: {
    marginTop: spaces.xxl,
    gap: spaces.sm,
  },
});
```

## Rules

- **ALWAYS** use design tokens for colors, fonts, spaces, borders — never hardcode `#hex`, pixel values, or font names.
- **ALWAYS** use `StyleSheet.create()` — never inline styles (except dynamic values).
- **ALWAYS** separate View (.tsx), ViewModel (.viewModel.ts), and Styles (.styles.ts).
- **ALWAYS** use the component library (Typography, Button, Icon, Input) before building custom components.
- **NEVER** import design system tokens in ViewModels — they are presentation-only.
- **NEVER** put API calls or business logic in Views — that's the ViewModel's job.
- **NEVER** hardcode strings — use i18n keys for user-facing text.

## Checklist

- [ ] Screen split into View + ViewModel + Styles
- [ ] All colors from `@designSystem/colors` tokens
- [ ] All spacing from `@designSystem/spaces` tokens
- [ ] Uses Typography/Button/Icon from component library
- [ ] Styles in `StyleSheet.create()`, not inline
- [ ] ViewModel handles state and logic, View handles rendering
- [ ] No hardcoded colors, sizes, or font names
